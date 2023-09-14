//
//  SearchScreenMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 07.06.2023.
//

import Foundation

final class SearchScreenMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(
        location: Location,
        weather: WeatherData?,
        index: Int
    ) -> WeatherModel.Components.Current {
        var backgroundColor = BackgroundType.dayClouds
        var cityName = location.city ?? ""
        var description = ""
        var temperature = "––"
        var temperatureRange = ""
        var time = ""
        
        if let weather = weather {
            guard let today = weather.daily.first else { fatalError() }
            
            let dayTime = dateFormatter.format(
                weather.current.dt,
                with: weather.timezoneOffset
            )
            
            backgroundColor = weatherFormatter.getBackgroundColor(
                weather.current.weather.first!.id,
                dayTime: dayTime
            )
            
            description = weatherFormatter.displayDescription(
                weather.current.weather.first!.description
            )
            temperature = weatherFormatter.displayTemperature(
                weather.current.temp
            )
            let minTemperature = weatherFormatter.displayTemperature(
                today.temperature.min
            )
            let maxTemperature = weatherFormatter.displayTemperature(
                today.temperature.max
            )
            temperatureRange = "H:\(maxTemperature) L:\(minTemperature)"
            time = dateFormatter.format(
                weather.current.dt,
                to: .time,
                with: weather.timezoneOffset
            )
        }
        
        if index == 0 {
            cityName = "My Location"
            time = location.city ?? ""
        }
        
        return WeatherModel.Components.Current(
            backgroundColor: backgroundColor,
            cityName: cityName,
            fullName: location.fullName,
            description: description,
            temperature: temperature,
            temperatureRange: temperatureRange,
            time: time
        )
    }
}
