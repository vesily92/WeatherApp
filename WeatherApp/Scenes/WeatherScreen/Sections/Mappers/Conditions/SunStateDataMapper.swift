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
        let sunrise = weatherData.current.sunrise
        let sunset = weatherData.current.sunset
        let timezoneOffset = weatherData.timezoneOffset
        
        let progress = calculateProgress(
            for: weatherData.current,
            with: timezoneOffset
        )
        
        var sunriseTime = ""
        var sunsetTime = ""
        
        var time = ""
        var nextEvent = ""
        
        if current < sunrise {
            sunriseTime = dateFormatter.format(
                sunrise,
                to: .time,
                with: timezoneOffset
            )
            sunsetTime = dateFormatter.format(
                sunset,
                to: .time,
                with: timezoneOffset
            )
            
            time = sunriseTime
            nextEvent = "Sunset: \(sunsetTime)"
            
        } else if current >= sunrise && current < sunset {
            sunriseTime = dateFormatter.format(
                weatherData.daily[1].sunrise,
                to: .time,
                with: timezoneOffset
            )
            sunsetTime = dateFormatter.format(
                sunset,
                to: .time,
                with: timezoneOffset
            )
            
            time = sunsetTime
            nextEvent = "Sunrise: \(sunriseTime)"
            
        } else {
            sunriseTime = dateFormatter.format(
                weatherData.daily[1].sunrise,
                to: .time,
                with: timezoneOffset
            )
            sunsetTime = dateFormatter.format(
                weatherData.daily[1].sunset,
                to: .time,
                with: timezoneOffset
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
    
    private func calculateProgress(
        for current: Current,
        with timezoneOffset: Int
    ) -> Double {
        let dayTimeCoef = 0.72
        let beforeAfterSunCoef = 0.14
        
        let currentDate = Date(timeIntervalSince1970: Double(current.dt))
        let sunrise = Double(current.sunrise)
        let sunset = Double(current.sunset)
        let startOfDay = currentDate
            .startOfDay(offset: timezoneOffset)
            .timeIntervalSince1970
        let endOfDay = currentDate
            .endOfDay(offset: timezoneOffset)
            .timeIntervalSince1970
        
        var secondsRange = 0.0
        var secondsFromStart = 0.0
        
        if current.dt < current.sunrise {
            secondsRange = sunrise - startOfDay
            secondsFromStart = Double(current.dt) - startOfDay
            
            return (secondsFromStart / secondsRange) * beforeAfterSunCoef

        } else if current.dt > current.sunset {
            secondsRange = endOfDay - sunset
            secondsFromStart = Double(current.dt) - sunset
            
            let relativeProgress = (secondsFromStart / secondsRange) * beforeAfterSunCoef
            
            return dayTimeCoef + beforeAfterSunCoef + relativeProgress
            
        } else {
            secondsRange = sunset - sunrise
            secondsFromStart = Double(current.dt) - sunrise
            
            let relativeProgress = (secondsFromStart / secondsRange) * dayTimeCoef
            
            return beforeAfterSunCoef + relativeProgress
        }
    }
}
