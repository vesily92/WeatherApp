//
//  FeelsLikeDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 01.06.2023.
//

import Foundation

final class FeelsLikeDataMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    private let weatherData: WeatherData
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter,
         weatherData: WeatherData) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
        self.weatherData = weatherData
    }
    
    func mapFeelsLikeData() -> WeatherModel.Components.Conditions {
        let temperature = weatherFormatter.displayTemperature(weatherData.current.feelsLike)
        
        let feelsLikeTemperature = weatherData.current.feelsLike
        let currentTemperature = weatherData.current.temp
        
        var description = ""
        
        if feelsLikeTemperature > currentTemperature {
            description = "Humidity is making it feel warmer."
        } else if feelsLikeTemperature < currentTemperature {
            description = "Wind is making it feel cooler."
        } else {
            description = "Similar to the actual temperature."
        }
        
        
        let feelsLike = WeatherModel.Components.FeelsLike(
            temperature: temperature,
            description: description
        )
        
        return WeatherModel.Components.Conditions(
            type: .feelsLike,
            feelsLike: feelsLike
        )
    }
}
