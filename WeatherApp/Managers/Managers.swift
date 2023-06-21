//
//  Managers.swift
//  WeatherApp
//
//  Created by Василий Пронин on 18.06.2023.
//

import Foundation

/// A type of manager container for `WeatherScreen`.
typealias IWeatherScreenManager = IWeatherScreenSectionManager & IWeatherManager & IGeocodingManager & ILocationManager

/// A type of manager container for `SearchScreen`.
typealias ISearchScreenManager = ISearchScreenSectionManager & IGeocodingManager

/// A type of manager container for `NewLocationScreen`.
typealias INewLocationScreenManager = IWeatherScreenSectionManager & IWeatherManager

// MARK: - WeatherScreenManager
/// Managers container object for `WeatherScreen`.
struct WeatherScreenManager {
    let weatherSectionManager: IWeatherScreenSectionManager
    let weatherManager: IWeatherManager
    let geocodingManager: IGeocodingManager
    let locationManager: ILocationManager
}

// MARK: - WeatherScreenManager + IWeatherScreenManager
extension WeatherScreenManager: IWeatherScreenManager {
    func setupCurrentWith(data: WeatherModel.Data) -> WeatherModel.ViewModel.Current {
        weatherSectionManager.setupCurrentWith(data: data)
    }
    
    func createSectionsWith(data: WeatherModel.Data) -> [Section] {
        weatherSectionManager.createSectionsWith(data: data)
    }
    
    func fetchWeatherFor(
        _ location: Location,
        completion: @escaping (WeatherModel.Data
        ) -> Void) {
        weatherManager.fetchWeatherFor(location, completion: completion)
    }
    
    func fetchLocation(
        with request: GeocodingManager.RequestType,
        completion: @escaping ([Location]) -> Void) {
        geocodingManager.fetchLocation(with: request, completion: completion)
    }
    
    func getUserLocation(completion: @escaping ((Double, Double) -> Void)) {
        locationManager.getUserLocation(completion: completion)
    }
}

// MARK: - SearchScreenManager
/// Managers container object for `SearchScreen`.
struct SearchScreenManager {
    let searchSectionManager: ISearchScreenSectionManager
    let geocodingManager: IGeocodingManager
}

// MARK: - SearchScreenManager + ISearchScreenManager
extension SearchScreenManager: ISearchScreenManager {
    func createSections(
        with data: [WeatherModel.Data],
        delegate: IListSectionConfiguratorDelegate
    ) -> [Section] {
        searchSectionManager.createSections(with: data, delegate: delegate)
    }
    
    func fetchLocation(
        with request: GeocodingManager.RequestType,
        completion: @escaping ([Location]) -> Void
    ) {
        geocodingManager.fetchLocation(with: request, completion: completion)
    }
}

// MARK: - NewLocationScreenManager
/// Managers container object for `NewLocationScreen`.
struct NewLocationScreenManager {
    let weatherSectionManager: IWeatherScreenSectionManager
    let weatherManager: IWeatherManager
}

// MARK: - NewLocationScreenManager + INewLocationScreenManager
extension NewLocationScreenManager: INewLocationScreenManager {
    func setupCurrentWith(
        data: WeatherModel.Data
    ) -> WeatherModel.ViewModel.Current {
        weatherSectionManager.setupCurrentWith(data: data)
    }
    
    func createSectionsWith(data: WeatherModel.Data) -> [Section] {
        weatherSectionManager.createSectionsWith(data: data)
    }
    
    func fetchWeatherFor(
        _ location: Location,
        completion: @escaping (WeatherModel.Data) -> Void
    ) {
        weatherManager.fetchWeatherFor(location, completion: completion)
    }
}
