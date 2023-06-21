//
//  SectionsManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import Foundation

/// A type that provides configured sections for collection view on ``WeatherViewController``.
protocol IWeatherScreenSectionManager {
    
    /// Provides view model for ``CurrentWeatherView``.
    /// - Parameter data: The data received from network call.
    /// - Returns: View model for ``CurrentWeatherView``.
    func setupCurrentWith(
        data: WeatherModel.Data
    ) -> WeatherModel.ViewModel.Current
    
    /// Provides configured sections for collection view on ``WeatherViewController``.
    /// - Parameter data: The data received from network call.
    /// - Returns: Array of configured sections.
    func createSectionsWith(data: WeatherModel.Data) -> [Section]
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
    func setupCurrentWith(data: WeatherModel.Data) -> WeatherModel.ViewModel.Current {
        sectionService.setupCurrentWith(data: data)
    }
    
    func createSectionsWith(data: WeatherModel.Data) -> [Section] {
        guard let weather = data.weather else { return [] }
            
        if weather.alerts != nil {
            return sectionService.createWeatherSections(
                for: SectionType.WeatherScreen.allCases,
                with: data
            )
            
        } else {
            return sectionService.createWeatherSections(
                for: [.hourly, .daily, .conditions, .footer],
                with: data
            )
        }
    }
}
