//
//  ManagerAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

/// Manager assembly object.
final class ManagerAssembly {
    
    private let service = ServiceAssembly()
    
    /// CoreData location service
    lazy var coreDataLocationManager: ICoreDataLocationManager = {
        return CoreDataLocationManager(
            coreDataService: service.coreDataLocationService
        )
    }()
    
    /// Location manager.
    lazy var locationManager: ILocationManager = {
        return LocationManager()
    }()
    
    /// Weather manager.
    lazy var weatherManager: IWeatherManager = {
        return WeatherManager(weatherService: service.weatherService)
    }()
    
    /// Geocoding manager.
    lazy var geocodingManager: IGeocodingManager = {
        return GeocodingManager(geocodingService: service.geocodingService)
    }()
    
    /// Section configuration manager for `WeatherScreen`.
    lazy var weatherScreenSectionManager: IWeatherScreenSectionManager = {
        return WeatherScreenSectionManager(
            sectionService: service.weatherScreenSectionService
        )
    }()
    
    /// Mapping manager.
    lazy var mappingManager: IMappingManager = {
        return MappingManager()
    }()
}
