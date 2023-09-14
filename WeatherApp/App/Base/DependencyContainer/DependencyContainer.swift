//
//  DependencyContainer.swift
//  WeatherApp
//
//  Created by Василий Пронин on 18.06.2023.
//

/// Dependency container object.
final class DependencyContainer {
    
    private lazy var locationManager = ManagerAssembly().locationManager
    private lazy var geocodingManager = ManagerAssembly().geocodingManager
    private lazy var weatherManager = ManagerAssembly().weatherManager
}

// MARK: - DependencyContainer + IManagersFactory

extension DependencyContainer: IManagersFactory {
    
    func makeSearchScreenManager(
        coreDataManager: ICoreDataLocationManager,
        mappingManager: IMappingManager
    ) -> ISearchScreenManagersWrapper {
        SearchScreenManagersWrapper(
            coreDataManager: coreDataManager,
            mappingManager: mappingManager,
            weatherManager: weatherManager,
            geocodingManager: geocodingManager,
            locationManager: locationManager
        )
    }
}
