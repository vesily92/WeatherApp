//
//  PressureDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 01.06.2023.
//

import Foundation

final class PressureDataMapper {
    
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
    
    func mapPressureData() -> WeatherModel.Components.Conditions {
        let currentPressure = weatherData.current.pressure
        let current = Double(currentPressure) / 1.33322387415
        
        let min = 700.0
        let max = 820.0
        let percent = (current - min) / ((max - min) / 100)
        
        let degrees = percent / 100 * (395 - 145) - 125
        
        var averagePressure = 0
        (1...2).forEach { i in
            averagePressure += weatherData.hourly[i].pressure
            averagePressure /= i
        }
        
        var state: WeatherModel.Components.Pressure.State = .stable
        
        if averagePressure > currentPressure {
            state = .rising
        } else if averagePressure < currentPressure {
            state = .falling
        }
        
        let pressureString = weatherFormatter.displayPressure(
            weatherData.current.pressure
        )
        
        let pressure = WeatherModel.Components.Pressure(
            state: state,
            pressure: pressureString,
            rotationDegrees: degrees
        )
        
        return WeatherModel.Components.Conditions(
            type: .pressure,
            pressure: pressure
        )
    }
}
