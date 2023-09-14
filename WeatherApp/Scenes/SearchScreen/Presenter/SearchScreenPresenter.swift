//
//  SearchScreenPresenter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import Foundation

protocol ISearchScreenDelegate: AnyObject {
    func didSelectLocation(with pageIndex: Int)
    func didAddLocation(with data: WeatherModel.Data)
    func didRemoveLocation(by index: Int)
}

protocol ISearchScreenRouter {
    func route(to target: SearchScreenTarget)
}

protocol ISearchViewPresenter {
    func renderSearchView()
    func updateWith(_ data: [WeatherModel.Data])
    func search(with query: String)
    func handleCellSelection(at index: Int)
    func handleCellRemoval(at index: Int)
    
}

protocol IResultsViewPresenter {
    func numberOfResults() -> Int
    func result(at index: Int) -> String
    func showLocation(by index: Int)
}

final class SearchScreenPresenter {
    
    weak var searchView: ISearchViewController?
    weak var resultsView: IResultsViewController?
    
    weak var delegate: ISearchScreenDelegate?
    
    var data: [WeatherModel.Data] = [] {
        didSet { renderSearchView() }
    }
    
    private let router: ISearchScreenRouter
    private let manager: ISearchScreenManager
    
    private var foundLocations: [Location] = []
    
    init(router: ISearchScreenRouter,
         manager: ISearchScreenManager,
         data: [WeatherModel.Data],
         delegate: ISearchScreenDelegate) {
        
        self.router = router
        self.manager = manager
        self.data = data
        self.delegate = delegate
    }
}

extension SearchScreenPresenter: ISearchViewPresenter {
    
    func renderSearchView() {
        guard let searchView = searchView else { return }
        let sections = manager.createSections(
            with: data,
            delegate: searchView
        )
        let viewModel = WeatherModel.ViewModel.ListScreen(sections: sections)
        searchView.render(with: viewModel)
    }
    
    func search(with query: String) {
        manager.fetchLocation(
            with: .cityName(cityName: query)
        ) { [weak self] locations in
            self?.foundLocations = locations
            
            DispatchQueue.main.async {
                self?.resultsView?.showResults(with: locations, and: query)
            }
        }
    }
    
    func updateWith(_ data: [WeatherModel.Data]) {
        self.data = data
    }

    func handleCellSelection(at index: Int) {
        delegate?.didSelectLocation(with: index)
        router.route(to: .weatherScreen)
    }
    
    func handleCellRemoval(at index: Int) {
        delegate?.didRemoveLocation(by: index)
    }
}

extension SearchScreenPresenter: IResultsViewPresenter {
    func numberOfResults() -> Int {
        foundLocations.count
    }
    
    func result(at index: Int) -> String {
        foundLocations[index].fullName ?? ""
    }
    
    func showLocation(by index: Int) {
        let location = foundLocations[index]
        var locations: [Location] = []
        data.forEach { model in
            locations.append(model.location)
        }
        let isNew = !locations
            .dropFirst()
            .contains {
                $0.latitude == location.latitude && $0.longitude == location.longitude
            }
        
        router.route(
            to: .newLocationScreen(
                location: location,
                isNew: isNew,
                delegate: self
            )
        )
    }
}

extension SearchScreenPresenter: INewLocationDelegate {
    func didAddNewLocation(with data: WeatherModel.Data) {
        self.data.append(data)
        delegate?.didAddLocation(with: data)
    }
}
