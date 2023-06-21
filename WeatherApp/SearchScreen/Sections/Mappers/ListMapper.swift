//
//  ListMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 07.06.2023.
//

import Foundation

final class ListMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(
        _ models: [WeatherModel.Data]
    ) -> [WeatherModel.ViewModel.Current] {
        var viewModels: [WeatherModel.ViewModel.Current] = []
        
        models.enumerated().forEach { (index, model) in
            let current = setupModel(data: model, index: index)
            viewModels.append(current)
        }
        return viewModels
    }
    
    private func setupModel(
        data: WeatherModel.Data,
        index: Int
    ) -> WeatherModel.ViewModel.Current {
        
        var cityName = data.location.city ?? ""
        var description = ""
        var temperature = ""
        var temperatureRange = ""
        var time = ""
        
        if let weather = data.weather {
            guard let today = weather.daily.first else { fatalError() }
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
            time = data.location.city ?? ""
        }
        
        return WeatherModel.ViewModel.Current(
            cityName: cityName,
            fullName: data.location.fullName,
            description: description,
            temperature: temperature,
            temperatureRange: temperatureRange,
            time: time
        )
    }
}
