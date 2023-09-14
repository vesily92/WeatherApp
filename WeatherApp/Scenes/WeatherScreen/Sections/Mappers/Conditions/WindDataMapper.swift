//
//  WindDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 01.06.2023.
//

import Foundation

final class WindDataMapper {
    
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
    
    func mapWindData() -> WeatherModel.ViewModel.Conditions {
        let speed = weatherFormatter.displayUVI(weatherData.current.windSpeed)
        let degrees = weatherData.current.windDeg
        
        let wind = WeatherModel.ViewModel.Wind(speed: speed, degrees: degrees)
        
        return WeatherModel.ViewModel.Conditions(type: .wind, wind: wind)
    }
}
