//
//  DependencyContainer.swift
//  WeatherApp
//
//  Created by Василий Пронин on 18.06.2023.
//

import Foundation

/// A type that provides methods to create containers for managers.
protocol IManagersFactory {
    
    /// Creates managers container for `WeatherScreen`.
    /// - Returns: Container object.
    func makeWeatherScreenManager() -> IWeatherScreenManager
    
    /// Creates managers container for `SearchScreen`.
    /// - Returns: Container object.
    func makeSearchScreenManager() -> ISearchScreenManager
    
    /// Creates managers container for `NewLocationScreen`.
    /// - Returns: Container object.
    func makeNewLocationScreenManager() -> INewLocationScreenManager
}

// MARK: - DependencyContainer
/// Dependency container object.
final class DependencyContainer {
    
    private lazy var locationManager = ManagerAssembly().locationManager
    private lazy var geocodingManager = ManagerAssembly().geocodingManager
    private lazy var weatherManager = ManagerAssembly().weatherManager
    private lazy var weatherSectionManager = ManagerAssembly().weatherScreenSectionManager
    private lazy var searchSectionManager = ManagerAssembly().searchScreenSectionManager
}

// MARK: - DependencyContainer + IManagersFactory
extension DependencyContainer: IManagersFactory {
    func makeWeatherScreenManager() -> IWeatherScreenManager {
        WeatherScreenManager(
            weatherSectionManager: weatherSectionManager,
            weatherManager: weatherManager,
            geocodingManager: geocodingManager,
            locationManager: locationManager
        )
    }
    
    func makeSearchScreenManager() -> ISearchScreenManager {
        SearchScreenManager(
            searchSectionManager: searchSectionManager,
            geocodingManager: geocodingManager
        )
    }
    
    func makeNewLocationScreenManager() -> INewLocationScreenManager {
        NewLocationScreenManager(
            weatherSectionManager: weatherSectionManager,
            weatherManager: weatherManager
        )
    }
}
