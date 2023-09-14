//
//  Factory.swift
//  WeatherApp
//
//  Created by Василий Пронин on 13.07.2023.
//

/// A type that provides methods to create containers for managers.
protocol IManagersFactory {
    
    /// Creates managers container for `SearchScreen`.
    /// - Returns: Container object.
    func makeSearchScreenManager(
        coreDataManager: ICoreDataLocationManager,
        mappingManager: IMappingManager
    ) -> ISearchScreenManager
}

