//
//  PrecipitationDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 01.06.2023.
//

import Foundation

final class PrecipitationDataMapper {
    
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
    
    func mapPrecipitationData() -> WeatherModel.ViewModel.Conditions {
        let currentPrecipitation = weatherData.current.rain?.oneHour ?? 0
        let dailyPrecipitation = weatherData.daily.first?.rain ?? 0
        
        var expectedPrecipitation = "None expected in next 8 days."
        var expectedDay = ""
        
        for (index, daily) in weatherData.daily.enumerated() {
            if let nextRain = daily.rain {
                let precipitation = weatherFormatter.displayPrecipitation(nextRain)
                if index <= 1 {
                    expectedPrecipitation = "\(precipitation) expected"
                    expectedDay = "in next 24h."
                } else {
                    expectedPrecipitation = "Next expected is \(precipitation)"
                    let weekday = dateFormatter.format(daily.dt, to: .weekdayShort)
                    expectedDay = "on \(weekday)"
                }
                break
            }
        }
        
        let todayPrecipitation = weatherFormatter.displayPrecipitation(dailyPrecipitation)
        let expectation = "\(expectedPrecipitation) \(expectedDay)"
        let isRainfall = currentPrecipitation > 0
        
        let precipitation = WeatherModel.ViewModel.Precipitation(
            pop: todayPrecipitation,
            expectation: expectation,
            isRainfall: isRainfall
        )
        
        return WeatherModel.ViewModel.Conditions(
            type: isRainfall ? .rainfall : .precipitation,
            precipitation: precipitation
        )
    }
}
