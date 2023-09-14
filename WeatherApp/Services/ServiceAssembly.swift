//
//  ServiceAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

/// Service assembly object.
final class ServiceAssembly {
    
    private var coreDataService = CoreDataService.shared
    private var networkService = NetworkService.shared
    private var sectionService = SectionService.shared
    
    /// CoreData location service.
    lazy var coreDataLocationService: ICoreDataLocationService = {
        return coreDataService
    }()
    /// Networking service.
    lazy var weatherService: IWeatherService = {
        return networkService
    }()
    
    /// Geocoding service.
    lazy var geocodingService: IGeocodingService = {
        return networkService
    }()
    
    /// Section configuration service for `WeatherScreen`.
    lazy var weatherScreenSectionService: IWeatherScreenSectionService = {
        return sectionService
    }()
}
