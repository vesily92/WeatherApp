//
//  DailyMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

final class DailyMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(_ model: WeatherData) -> [WeatherModel.ViewModel.Daily] {
        var dailyViewModels: [WeatherModel.ViewModel.Daily] = []
        
        let weeklyExtremums = findExtremums(for: model)
        
        model.daily.enumerated().forEach { (index, daily) in
            guard let weather = daily.weather.first else { return }
            
            var time = ""
            var currentTemperature: Double?
            
            if index == 0 {
                time = "Today"
                currentTemperature = model.current.temp
            } else {
                time = dateFormatter.format(
                    daily.dt,
                    to: .weekdayShort,
                    with: model.timezoneOffset
                )
            }
            
            let minTemperature = weatherFormatter.displayTemperature(
                daily.temperature.min
            )
            
            let maxTemperature = weatherFormatter.displayTemperature(
                daily.temperature.max
            )
            
            let symbolName = weatherFormatter.getWeatherSymbolName(
                weather.id,
                icon: weather.icon
            )
            
            let pop = weatherFormatter.displayPop(
                daily.pop,
                weatherID: weather.id
            )
            
            let startPoint = calculateCoordinates(
                with: daily, and: weeklyExtremums
            ).startPoint
            
            let endPoint = calculateCoordinates(
                with: daily, and: weeklyExtremums
            ).endPoint
            
            let currentPoint = calculateCurrentTemperaturePoint(
                with: currentTemperature, and: weeklyExtremums
            )
            let indicatorViewModel = WeatherModel.ViewModel.IndicatorViewModel(
                startPoint: startPoint,
                endPoint: endPoint,
                currentPoint: currentPoint,
                minTemperature: Int(daily.temperature.min.roundDecimal()),
                maxTemperature: Int(daily.temperature.max.roundDecimal())
            )
                        
            let dailyViewModel = WeatherModel.ViewModel.Daily(
                time: time,
                minTemperature: minTemperature,
                maxTemperature: maxTemperature,
                symbolName: symbolName,
                indicatorViewModel: indicatorViewModel,
                pop: pop
            )
            dailyViewModels.append(dailyViewModel)
        }
        
        return dailyViewModels
    }
    
    private func findExtremums(for model: WeatherData) -> (min: Double, max: Double) {
        var minTemperatureArray: [Double] = []
        var maxTemperatureArray: [Double] = []
        
        model.daily.forEach { daily in
            minTemperatureArray.append(daily.temperature.min)
            maxTemperatureArray.append(daily.temperature.max)
        }
        
        guard let minTemperature = minTemperatureArray.min(),
              let maxTemperature = maxTemperatureArray.max()  else {
            return (0, 0)
        }
        
        return (minTemperature, maxTemperature)
    }
    
    private func calculateCoordinates(
        with model: Daily,
        and extremums: (min: Double, max: Double)
    ) -> (startPoint: CGFloat, endPoint: CGFloat) {
        
        let minTemp = extremums.min
        let maxTemp = extremums.max
        
        let totalRange = maxTemp - minTemp
     
        let start = abs(minTemp - model.temperature.min)
        let end = abs((model.temperature.max - model.temperature.min) + start)
        
        let startPoint = CGFloat(start / totalRange)
        let endPoint = CGFloat(end / totalRange)
        
        return (startPoint, endPoint)
    }
    
    private func calculateCurrentTemperaturePoint(
        with currentTemperature: Double?,
        and extremums: (min: Double, max: Double)
    ) -> CGFloat? {
        guard let currentTemperature = currentTemperature else { return nil }
        
        let minTemp = extremums.min
        let maxTemp = extremums.max
        
        let totalRange = maxTemp - minTemp
        let start = abs(currentTemperature - minTemp)

        return CGFloat(start / totalRange)
    }
}

