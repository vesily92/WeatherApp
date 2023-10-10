//
//  CurrentMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 29.03.2023.
//

import Foundation

final class CurrentMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(_ model: WeatherData? = nil, location: Location) -> WeatherModel.Components.Current {
        
        guard let model = model else {
            return WeatherModel.Components.Current(
                backgroundColor: nil,
                cityName: location.city ?? "",
                fullName: location.fullName,
                description: nil,
                temperature: "––",
                temperatureRange: nil,
                time: nil
            )
        }
        
        guard let today = model.daily.first else { fatalError() }
        
        let backgroundColor = weatherFormatter.getBackgroundColor(
            for: model.current,
            with: model.timezoneOffset
        )
        
        let time = dateFormatter.format(
            model.current.dt,
            to: .time,
            with: model.timezoneOffset
        )
        
        let description = weatherFormatter.displayDescription(
            model.current.weather.first!.description
        )
        let temperature = weatherFormatter.displayTemperature(
            model.current.temp
        )
        let minTemperature = weatherFormatter.displayTemperature(
            today.temperature.min
        )
        let maxTemperature = weatherFormatter.displayTemperature(
            today.temperature.max
        )
        let temperatureRange = "H:\(maxTemperature) L:\(minTemperature)"
        
        return WeatherModel.Components.Current(
            backgroundColor: backgroundColor,
            cityName: location.city,
            fullName: location.fullName,
            description: description,
            temperature: temperature,
            temperatureRange: temperatureRange,
            time: time
        )
    }
}
