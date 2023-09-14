//
//  Date + startOfDay, endOfDay.swift
//  WeatherApp
//
//  Created by Василий Пронин on 24.05.2023.
//

import Foundation

extension Date {
    
    func startOfDay(offset: Int) -> Date {
        let timeZone = TimeZone(secondsFromGMT: offset) ?? TimeZone.current
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay(offset: Int) -> Date {
        let timeZone = TimeZone(secondsFromGMT: offset) ?? TimeZone.current
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        return calendar.date(
            byAdding: components,
            to: startOfDay(offset: offset)
        )!
    }
}
