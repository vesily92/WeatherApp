//
//  SectionsManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import Foundation

/// A type that provides configured sections for collection view on ``WeatherViewController``.
protocol IWeatherScreenSectionManager {
    
    /// Provides configured sections for collection view on ``WeatherViewController``.
    /// - Parameter data: The data received from network call.
    /// - Returns: Array of configured sections.
    func createSectionsWith(
        location: Location,
        weatherData: WeatherData?
    ) -> [Section]
}

// MARK: - WeatherScreenSectionManager

/// Manager that provides sections for collection view on ``WeatherViewController``.
final class WeatherScreenSectionManager {
    
    let sectionService: IWeatherScreenSectionService
    
    init(sectionService: IWeatherScreenSectionService) {
        self.sectionService = sectionService
    }
}

// MARK: - WeatherScreenSectionManager + IWeatherScreenSectionManager

extension WeatherScreenSectionManager: IWeatherScreenSectionManager {
    
    func createSectionsWith(
        location: Location,
        weatherData: WeatherData? = nil
    ) -> [Section] {
        guard let weatherData = weatherData else { return [] }
        
        if weatherData.alerts != nil {
            return sectionService.createWeatherSections(
                for: SectionType.WeatherScreen.allCases
            )
            
        } else {
            return sectionService.createWeatherSections(
                for: [.spacer, .hourly, .daily, .conditions, .footer]
            )
        }
    }
}
