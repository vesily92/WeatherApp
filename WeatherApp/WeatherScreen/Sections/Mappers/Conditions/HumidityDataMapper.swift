//
//  HumidityDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 01.06.2023.
//

import Foundation

final class HumidityDataMapper {
    
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
    
    func mapHumidityData() -> WeatherModel.ViewModel.Conditions {
        let dewPoint = weatherFormatter.displayTemperature(weatherData.current.dewPoint)
        
        let humidityPercent = "\(weatherData.current.humidity) %"
        let description = "The dew point is \(dewPoint) right now"
        
        let humidity = WeatherModel.ViewModel.Humidity(
            humidity: humidityPercent,
            description: description
        )
        
        return WeatherModel.ViewModel.Conditions(
            type: .humidity,
            humidity: humidity
        )
    }
}
