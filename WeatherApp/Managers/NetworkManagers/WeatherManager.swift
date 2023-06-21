//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 30.03.2023.
//

import Foundation

/// A type that provides weather data from network calls wrapped into view model.
protocol IWeatherManager {
    
    /// Provides ``WeatherModel.Data`` object.
    /// - Parameters:
    ///   - location: ``Location`` object that specifies the network call destination.
    ///   - completion: Returns ``WeatherModel.Data`` object on completion.
    func fetchWeatherFor(
        _ location: Location,
        completion: @escaping (WeatherModel.Data) -> Void
    )
}

// MARK: - WeatherManager
/// Manager that provides weather data from network calls wrapped into view model.
final class WeatherManager {
    
    let weatherService: IWeatherService
    
    init(weatherService: IWeatherService) {
        self.weatherService = weatherService
    }
}

// MARK: - WeatherManager + IWeatherManager
extension WeatherManager: IWeatherManager {
    func fetchWeatherFor(
        _ location: Location,
        completion: @escaping (WeatherModel.Data) -> Void
    ) {
        weatherService.fetchWeather(for: location) { weather in
            let response = WeatherModel.Data(
                location: location,
                weather: weather
            )
            
            completion(response)
        }
    }
}
