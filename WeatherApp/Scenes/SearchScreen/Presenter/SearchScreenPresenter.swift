//
//  SearchScreenPresenter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import Foundation

protocol ISearchScreenPresenter {
    
    func render()
    func updateWith(viewModels: [WeatherModel.ViewModel])
    func search(with query: String)
    func getViewModel(by index: Int) -> WeatherModel.Components.Current
    func handleCellSelection(at index: Int)
    func handleCellRemoval(at index: Int)
    func handleCellReorder(_ viewModels: [WeatherModel.ViewModel])
}

protocol IResultsViewPresenter {
    
    func numberOfResults() -> Int
    func getQuery() -> String
    func getResult(at index: Int) -> String
    func showLocation(by index: Int)
}

final class SearchScreenPresenter {
    
    weak var searchView: ISearchScreenViewController?
    weak var resultsView: IResultsViewController?
    
    var viewModels: [WeatherModel.ViewModel] {
        get {
            var result: [WeatherModel.ViewModel] = []
            isolatedQueue.sync {
                result = self._viewModels
            }
            return result
        }
        set {
            isolatedQueue.async { self._viewModels = newValue }
        }
    }
    private var _viewModels: [WeatherModel.ViewModel] = []
    
    private var storedLocations: [Location] = []
    private var foundLocations: [Location] = []
    private var query: String = ""
    
    private let router: ISearchScreenRouter
    private let searchScreenManager: ISearchScreenManagersWrapper
    
    private let isolatedQueue = DispatchQueue(label: "SearchScreenQueue")
    
    init(router: ISearchScreenRouter,
         searchScreenManager: ISearchScreenManagersWrapper,
         viewModels: [WeatherModel.ViewModel]) {
        
        self.router = router
        self.searchScreenManager = searchScreenManager
        self.viewModels = viewModels
        
        viewModels.forEach { viewModel in
            storedLocations.append(viewModel.location)
        }
        
        searchView?.render(with: viewModels)
        
        self.searchScreenManager.getUserLocation { [weak self] latitude, longitude in
            self?.fetchData(latitude: latitude, longitude: longitude)
        }
        
        NotificationCenter.default.addObserver(
            forName: .updateView,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let object = notification
                .object as? [NotificationKey: WeatherModel.ViewModel],
                  let viewModel = object[NotificationKey.viewModel] else {
                return
            }
            if let index = self?.viewModels.firstIndex(where: {
                $0.location.city == viewModel.location.city
            }) {
                self?.viewModels[index] = viewModel
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func fetchData(latitude: Double, longitude: Double) {
        guard let location = storedLocations.first else { return }
        
        if location.latitude == latitude && location.longitude == longitude {
            storedLocations.enumerated().forEach { (index, location) in
                fetchWeather(for: location, by: index)
            }
            
        } else {
            searchScreenManager.fetchLocation(
                with: .coordinates(latitude: latitude, longitude: longitude)
            ) { [weak self] locations in
                guard let location = locations.first,
                      let self = self else {
                    return
                }
                
                self.storedLocations[0] = location
                self.storedLocations.enumerated().forEach{ (index, location) in
                    self.fetchWeather(for: location, by: index)
                }
            }
        }
    }
    
    private func fetchWeather(for location: Location, by index: Int) {
        searchScreenManager.fetchWeatherFor(location) { [weak self] response in
            guard let self = self else { return }
            let viewModel = self.searchScreenManager.map(
                .complete(
                    location: location,
                    weather: response.weather,
                    index: index
                )
            )
            
            self.viewModels[index] = viewModel
            self.searchView?.sendUpdated(viewModels: self.viewModels)
            
            DispatchQueue.main.async {
                self.searchView?.render(with: self.viewModels)
            }
        }
    }
}

// MARK: - SearchScreenPresenter + ISearchScreenPresenter

extension SearchScreenPresenter: ISearchScreenPresenter {
    
    func removeLocation(at index: Int) {
        viewModels.remove(at: index)
    }
    
    func render() {
        searchView?.render(with: viewModels)
    }
    
    func search(with query: String) {
        self.query = query
        
        let formatedQuery = query.replacingOccurrences(of: " ", with: "_")
        
        searchScreenManager.fetchLocation(
            with: .cityName(cityName: formatedQuery)
        ) { [weak self] locations in
            self?.foundLocations = locations
            
            DispatchQueue.main.async {
                self?.resultsView?.showResults(with: locations, and: query)
            }
        }
    }
    
    func updateWith(viewModels: [WeatherModel.ViewModel]) {
        self.viewModels = viewModels
    }
    
    func getViewModel(by index: Int) -> WeatherModel.Components.Current {
        return viewModels[index].list
    }
    
    func handleCellSelection(at index: Int) {
        router.route(
            to: .weatherScreen(
                viewModels: viewModels,
                index: index
            )
        )
    }
    
    func handleCellRemoval(at index: Int) {
        searchScreenManager.delete(viewModels[index].location)
        storedLocations.remove(at: index)
        viewModels.remove(at: index)
        render()
    }
    
    func handleCellReorder(_ viewModels: [WeatherModel.ViewModel]) {
        self.viewModels = viewModels
        
        var locations: [Location] = []
        viewModels.dropFirst().forEach { viewModel in
            locations.append(viewModel.location)
        }
        searchScreenManager.reorder(locations)
        render()
    }
}

// MARK: - SearchScreenPresenter + IResultsViewPresenter

extension SearchScreenPresenter: IResultsViewPresenter {
    func numberOfResults() -> Int {
        foundLocations.count
    }
    
    func getQuery() -> String {
        return query
    }
    
    func getResult(at index: Int) -> String {
        guard index < foundLocations.count else { return "" }
        return foundLocations[index].fullName ?? ""
    }
    
    func showLocation(by index: Int) {
        let newIndex = storedLocations.count + 1
        let location = foundLocations[index]
        
        let isNew = !storedLocations
            .dropFirst()
            .contains {
                $0.latitude == location.latitude &&
                $0.longitude == location.longitude
            }
        
        if storedLocations.contains(location) {
            let index = storedLocations.firstIndex(of: location)!
            let viewModel = viewModels[index]
            
            router.route(
                to: .newLocationScreen(
                    viewModel: viewModel,
                    isNew: isNew,
                    delegate: self
                )
            )
            
        } else {
            let viewModel = searchScreenManager.map(
                .initial(location: location, index: newIndex)
            )
            
            searchScreenManager.fetchWeatherFor(
                location
            ) { [weak self] response in
                let fetchedViewModel = self?.searchScreenManager.map(
                    .complete(
                        location: location,
                        weather: response.weather,
                        index: newIndex
                    )
                )
                NotificationCenter.default.post(
                    name: .updateView,
                    object: [NotificationKey.viewModel: fetchedViewModel]
                )
            }
            
            router.route(
                to: .newLocationScreen(
                    viewModel: viewModel,
                    isNew: isNew,
                    delegate: self
                )
            )
        }
    }
}

// MARK: - SearchScreenPresenter + INewLocationDelegate

extension SearchScreenPresenter: INewLocationDelegate {
    func cancel() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func didAddNewLocation(with viewModel: WeatherModel.ViewModel) {
        viewModels.append(viewModel)
        storedLocations.append(viewModel.location)
        searchView?.deactivateSearchController()
        searchScreenManager.save(viewModel.location)
        render()
    }
}
