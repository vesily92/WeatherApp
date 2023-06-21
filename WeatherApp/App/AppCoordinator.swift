//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 29.03.2023.
//

import UIKit

/// A type that provides application flow.
protocol ICoordinator {
    func start()
}

/// A type that can receive data updates.
protocol IUpdatableWithData {
    /// Updates data on receive.
    /// - Parameter data: The data received from network call.
    func updateWith(_ data: [WeatherModel.Data])
}

/// Application coordinator.
final class AppCoordinator: ICoordinator {
    // MARK: - Properties
    private let navigationController: UINavigationController
    private let coreDataManager: ICoreDataLocationManager
    
    private var data: [WeatherModel.Data] = [] {
        didSet { updateInterfaces() }
    }
    
    // MARK: - Initialisers
    init(navigationController: UINavigationController,
         coreDataManager: ICoreDataLocationManager) {
        self.navigationController = navigationController
        self.coreDataManager = coreDataManager
        
        getInitialData()
    }
    
    // MARK: - Internal Methods
    /// Launches main application flow.
    func start() {
        showWeatherScreen()
    }
    
    // MARK: - Private Methods
    /// Prepares initial data.
    private func getInitialData() {
        data = [
            WeatherModel.Data(
                location: Location(city: nil, latitude: nil, longitude: nil, country: nil, state: nil),
                weather: nil
            ),
            WeatherModel.Data(
                location: Location(city: "City of Westminster", latitude: 51.50998, longitude: -0.1337, country: "Great Britain", state: "London"),
                weather: nil
            ),
            WeatherModel.Data(
                location: Location(city: "New York", latitude: 39.31, longitude: -74.5, country: "USA", state: nil),
                weather: nil
            ),
            WeatherModel.Data(
                location: Location(city: "Berlin", latitude: 52.52, longitude: 13.40, country: "Germany", state: nil),
                weather: nil
            )
        ]
    }
    
    /// Shows main screen.
    private func showWeatherScreen() {
        let weatherScreenViewController = WeatherViewController()
        
        weatherScreenViewController.coordinator = self
        WeatherScreenAssembly(
            navigationController: navigationController,
            data: data
        ).assembly(viewController: weatherScreenViewController)
        
        weatherScreenViewController.onWeatherDataChange = { [weak self] data in
            self?.data = data
        }

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setToolbarHidden(false, animated: true)
        navigationController.setViewControllers(
            [weatherScreenViewController],
            animated: false
        )
    }
}

// MARK: - Extensions
extension AppCoordinator {
    /// Calls update method in every IUpdatableWithData ViewController.
    private func updateInterfaces() {
        navigationController.viewControllers.forEach {
            ($0 as? IUpdatableWithData)?.updateWith(data)
        }
    }
}
