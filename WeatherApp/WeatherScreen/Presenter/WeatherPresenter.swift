//
//  WeatherScreenPresenter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

protocol IWeatherScreenRouter {
    func route(to target: WeatherScreenTarget)
}

protocol IWeatherScreenPresenter {
    func numberOfPages() -> Int
    func setupPages()
    func updateWith(_ data: [WeatherModel.Data])

    func didTapSearchButton()
    // MOCK
    func readJSON()
}

final class WeatherPresenter {
    weak var view: IWeatherViewController?

    var data: [WeatherModel.Data]
    
    private let router: IWeatherScreenRouter
    private let manager: IWeatherScreenManager
    
    private var viewModels: [WeatherModel.ViewModel.WeatherScreen] = []
    private var dict: [Int: WeatherModel.Data] = [:]

    init(router: IWeatherScreenRouter,
         manager: IWeatherScreenManager,
         data: [WeatherModel.Data]) {
        self.router = router
        self.manager = manager
        self.data = data
        
        self.manager.getUserLocation { [weak self] latitude, longitude in
            self?.fetchData(latitude: latitude, longitude: longitude)
        }
    }

    private func fetchData(latitude: Double, longitude: Double) {
        guard let location = data.first?.location else { return }
        
        if location.latitude == latitude && location.longitude == longitude {
            data.enumerated().forEach { (index, data) in
                fetchWeather(for: data.location, by: index)
            }
            
        } else {
            manager.fetchLocation(
                with: .coordinates(latitude: latitude, longitude: longitude)
            ) { [weak self] locationArray in
                guard let location = locationArray.first,
                      let self = self else { return }

                let data = WeatherModel.Data(location: location, weather: nil)
                self.data.removeFirst()
                self.data.insert(data, at: 0)
                self.data.enumerated().forEach { (index, data) in
                    self.fetchWeather(for: data.location, by: index)
                }
            }
        }
    }
    
    private func fetchWeather(for location: Location, by index: Int) {
        manager.fetchWeatherFor(location) { [weak self] data in
            guard let self = self else { return }
            let viewModel = self.map(data)
            
            self.viewModels[index] = viewModel
            
            DispatchQueue.main.async {
                self.view?.updatePage(by: index, with: viewModel)
                self.dict[index] = data
                self.data = self.dict
                    .sorted(by: { $0.key < $1.key })
                    .map(\.value)
                self.view?.send(data: self.data)
            }
        }
    }
    
    private func map(
        _ data: WeatherModel.Data
    ) -> WeatherModel.ViewModel.WeatherScreen {
        let current = manager.setupCurrentWith(data: data)
        let sections = manager.createSectionsWith(data: data)
        
        return WeatherModel.ViewModel.WeatherScreen(
            current: current,
            sections: sections
        )
    }
}

extension WeatherPresenter: IWeatherScreenPresenter {
    func numberOfPages() -> Int {
        data.count
    }
    
    func setupPages() {
        if viewModels.isEmpty {
            var tempViewModels: [WeatherModel.ViewModel.WeatherScreen] = []
            
            data.forEach { model in
                let current = manager.setupCurrentWith(data: model)
                let tempViewModel = WeatherModel.ViewModel.WeatherScreen(
                    current: current,
                    sections: nil
                )
                tempViewModels.append(tempViewModel)
            }
            viewModels = tempViewModels
        }
        view?.preparePages(with: viewModels)
    }

    func updateWith(_ data: [WeatherModel.Data]) {
        self.data = data
    }
    
    func didTapSearchButton() {
        router.route(
            to: .searchScreen(
                data: data,
                delegate: self
            )
        )
    }
}

extension WeatherPresenter: ISearchScreenDelegate {
    func didSelectLocation(with pageIndex: Int) {
        view?.scrollTo(page: pageIndex)
    }

    func didAddLocation(with data: WeatherModel.Data) {
        let viewModel = map(data)
        self.data.append(data)
        viewModels.append(viewModel)
        view?.addPage(with: viewModel)
    }
    
    func didRemoveLocation(by index: Int) {
        data.remove(at: index)
        viewModels.remove(at: index)
        view?.removePage(by: index)
    }
}

extension WeatherPresenter {
    func readJSON() {
//        let weather = Bundle.main.decode(
//            WeatherData.self,
//            from: "mockWeatherData.json"
//        )
//
//        let response = WeatherModel.Response(
//            location: locations.first!,
//            weather: weather
//        )
//        let current = sectionManager.setupCurrentWith(response: response)
//        let sections = sectionManager.createSections(
//            with: response
//        )
//        let viewModel = WeatherModel.ViewModel.WeatherScreen(
//            current: current,
//            sections: sections
//        )
//        
//        viewModels = [viewModel]
        
//        self.view?.render()
    }
}
