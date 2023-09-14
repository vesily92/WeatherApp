//
//  SunStateDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 25.05.2023.
//

import Foundation

final class SunStateDataMapper {
    
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
    
    func mapSunStateData() -> WeatherModel.Components.Conditions {
        let current = weatherData.current.dt
        let timezoneOffset = weatherData.timezoneOffset
        let now = Date(
            timeIntervalSince1970: TimeInterval(current)
        )
        let progress = calculateCoordinates(
            current: now.timeIntervalSince1970,
            dayStart: now.startOfDay(offset: timezoneOffset).timeIntervalSince1970,
            dayEnd: now.endOfDay(offset: timezoneOffset).timeIntervalSince1970
        )
        
        var sunriseTime = ""
        var sunsetTime = ""
        
        var time = ""
        var nextEvent = ""
        
        if current < weatherData.current.sunrise {
            sunriseTime = dateFormatter.format(
                weatherData.current.sunrise,
                to: .time,
                with: weatherData.timezoneOffset
            )
            sunsetTime = dateFormatter.format(
                weatherData.current.sunset,
                to: .time,
                with: weatherData.timezoneOffset
            )
            
            time = sunriseTime
            nextEvent = "Sunset: \(sunsetTime)"
            
        } else if current >= weatherData.current.sunrise && current < weatherData.current.sunset {
            sunriseTime = dateFormatter.format(
                weatherData.daily[1].sunrise,
                to: .time,
                with: weatherData.timezoneOffset
            )
            sunsetTime = dateFormatter.format(
                weatherData.current.sunset,
                to: .time,
                with: weatherData.timezoneOffset
            )
            
            time = sunsetTime
            nextEvent = "Sunrise: \(sunriseTime)"
            
        } else {
            sunriseTime = dateFormatter.format(
                weatherData.daily[1].sunrise,
                to: .time,
                with: weatherData.timezoneOffset
            )
            sunsetTime = dateFormatter.format(
                weatherData.daily[1].sunset,
                to: .time,
                with: weatherData.timezoneOffset
            )
            
            time = sunriseTime
            nextEvent = "Sunset: \(sunsetTime)"
        }
        
        let isSunrise = !weatherFormatter.sunIsUp(
            weatherData.current.weather.first!.icon
        )
        
        let sunState = WeatherModel.Components.SunState(
            time: time,
            nextEvent: nextEvent,
            progress: progress,
            isSunrise: isSunrise
        )
        
        return WeatherModel.Components.Conditions(
            type: isSunrise ? .sunrise : .sunset,
            sunState: sunState
        )
    }
    
    private func calculateCoordinates(
        current: Double,
        dayStart: Double,
        dayEnd: Double
    ) -> Double {
        var secondsRange = 0.0
        var secondsFromStart = 0.0
        
        secondsRange = dayEnd - dayStart
        secondsFromStart = current - dayStart
        return secondsFromStart / secondsRange
    }
}
