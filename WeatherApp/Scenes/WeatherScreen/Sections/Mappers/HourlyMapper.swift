//
//  HourlyMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

final class HourlyMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(_ model: WeatherData) -> [WeatherModel.Components.Hourly] {
        let hourlyMapped = mapHourlyData(model)
        let sunriseMapped = mapSunriseData(model)
        let sunsetMapped = mapSunsetData(model)
        
        return getSortedViewModels(hourlyMapped, sunriseMapped, sunsetMapped)
    }
    
    private func mapHourlyData(_ model: WeatherData) -> [WeatherModel.Components.Hourly] {
        var hourlyViewModels = [WeatherModel.Components.Hourly]()
        
        model.hourly.enumerated().forEach { (index, hourly) in
            guard let weather = hourly.weather.first else { return }
            
            let temperature = weatherFormatter.displayTemperature(
                hourly.temp
            )
            let symbolName = weatherFormatter.getWeatherSymbolName(
                weather.id,
                icon: weather.icon
            )
            var pop = weatherFormatter.displayPop(
                hourly.pop,
                weatherID: weather.id
            )
            
            var time = dateFormatter.format(
                hourly.dt,
                to: .hour,
                with: model.timezoneOffset
            )
            
            if index == 0 {
                time = "Now"
                pop = nil
            }
            
            let hourlyViewModel = WeatherModel.Components.Hourly(
                cellType: .hourly,
                unixTime: hourly.dt,
                time: time,
                symbolName: symbolName,
                temperature: temperature,
                event: nil,
                pop: pop
            )
            
            hourlyViewModels.append(hourlyViewModel)
        }
        
        return hourlyViewModels
    }
    
    private func mapSunriseData(_ model: WeatherData) -> [WeatherModel.Components.Hourly] {
        var hourlyViewModels = [WeatherModel.Components.Hourly]()
        
        model.daily.forEach { daily in
            let time = dateFormatter.format(
                daily.sunrise,
                to: .time,
                with: model.timezoneOffset
            )
            let event = "Sunrise"
            let symbolName = "sunrise.fill"
            
            let hourlyViewModel = WeatherModel.Components.Hourly(
                cellType: .daily,
                unixTime: daily.sunrise,
                time: time,
                symbolName: symbolName,
                temperature: nil,
                event: event,
                pop: nil
            )
            
            hourlyViewModels.append(hourlyViewModel)
        }
        
        return hourlyViewModels
    }
    
    private func mapSunsetData(_ model: WeatherData) -> [WeatherModel.Components.Hourly] {
        var hourlyViewModels = [WeatherModel.Components.Hourly]()
        
        model.daily.forEach { daily in
            let time = dateFormatter.format(
                daily.sunset,
                to: .time,
                with: model.timezoneOffset
            )
            let event = "Sunset"
            let symbolName = "sunset.fill"
            
            let hourlyViewModel = WeatherModel.Components.Hourly(
                cellType: .daily,
                unixTime: daily.sunset,
                time: time,
                symbolName: symbolName,
                temperature: nil,
                event: event,
                pop: nil
            )
            
            hourlyViewModels.append(hourlyViewModel)
        }
        
        return hourlyViewModels
    }
    
    private func getSortedViewModels(_ arrays: [WeatherModel.Components.Hourly]...) -> [WeatherModel.Components.Hourly] {
        var array = arrays.flatMap { $0 }.sorted { $0.unixTime < $1.unixTime }
        
        guard let firstElement = array.first else { return [] }
        
        if firstElement.cellType == .daily {
            array.removeFirst()
        }
        
        let unixHour = 3600
        let pairs = zip(array, array.dropFirst())
        let filteredArray = pairs
            .filter { $1.unixTime - $0.unixTime <= unixHour }
            .compactMap { $0.0 }
        
        return filteredArray
    }
}
