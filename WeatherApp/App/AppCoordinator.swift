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
    
    /// Updates view models on receive.
    /// - Parameter data: Updated view models .
    func updateWith(viewModels: [WeatherModel.ViewModel])
}

/// Application coordinator.
final class AppCoordinator: ICoordinator {
    
    // MARK: Private Properties
    
    private let navigationController: UINavigationController
    private let coreDataManager: ICoreDataLocationManager
    private let mappingManager: IMappingManager

    private let isolatedQueue = DispatchQueue(label: "CoordinatorQueue")
    
    private var locations: [Location] = []
    
    private var _viewModels: [WeatherModel.ViewModel] = []
    private var viewModels: [WeatherModel.ViewModel] {
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
    
    // MARK: Initialisers
    
    init(navigationController: UINavigationController,
         coreDataManager: ICoreDataLocationManager,
         mappingManager: IMappingManager
    ) {
        self.navigationController = navigationController
        self.coreDataManager = coreDataManager
        self.mappingManager = mappingManager
    }
    
    // MARK: - Internal Methods
    
    /// Launches main application flow.
    func start() {
        startMainFlow()
    }
    
    // MARK: Private Methods
    
    private func startMainFlow() {
        
        let blancLocation = Location(
            city: nil,
            latitude: nil,
            longitude: nil,
            country: nil,
            state: nil
        )
        locations.append(blancLocation)
        
        fetchCoreData()
        createViewModels()
        setViewControllers()
    }
    
    private func fetchCoreData() {
        coreDataManager.fetch { [weak self] result in
            switch result {
            case .success(let locations):
                var fetchedLocations: [Location] = []
                
                locations.forEach { location in
                    let fetchedLocation = Location(
                        city: location.cityName,
                        latitude: location.latitude,
                        longitude: location.longitude,
                        country: location.country,
                        state: location.state
                    )
                    
                    fetchedLocations.append(fetchedLocation)
                }
                
                self?.locations.append(contentsOf: fetchedLocations)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createViewModels() {
        locations.enumerated().forEach { (index, location) in
            let viewModel = mappingManager.map(
                .initial(location: location, index: index)
            )
            viewModels.append(viewModel)
        }
    }
    
    private func setViewControllers() {
        let searchScreenViewController = SearchScreenViewController()
        searchScreenViewController.coordinator = self
        
        SearchScreenAssembly(
            navigationController: navigationController,
            coreDataManger: coreDataManager,
            mappingManager: mappingManager,
            viewModels: viewModels
        ).assembly(
            viewController: searchScreenViewController
        )
        searchScreenViewController
            .onViewModelsDidChange = { [weak self] viewModels in
                self?.viewModels = viewModels
                self?.updateInterfaces()
            }
        
        let weatherScreenViewController = WeatherScreenPageViewController()
        
        WeatherScreenAssembly(
            navigationController: navigationController,
            viewModels: viewModels
        ).assembly(
            viewController: weatherScreenViewController
        )
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.setToolbarHidden(false, animated: true)
        navigationController.setViewControllers(
            [searchScreenViewController, weatherScreenViewController],
            animated: false
        )
    }
}

// MARK: - Extensions

extension AppCoordinator {
    
    /// Calls update method in every IUpdatableWithData ViewController.
    private func updateInterfaces() {
        DispatchQueue.main.async { [self] in
            navigationController.viewControllers.forEach {
                ($0 as? IUpdatableWithData)?.updateWith(viewModels: viewModels)
            }
        }
    }
}
