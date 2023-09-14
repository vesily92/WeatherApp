//
//  DateFormatter + Extension.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

enum DayTime {
    case morning
    case day
    case evening
    case night
}

extension DateFormatter {
    
    enum DateFormat: String {
        case monthDayTime = "MMM d, HH:mm"
        case hour = "HH"
        case weekdayFull = "EEEE"
        case weekdayShort = "EE"
        case dayMonth = "d MMMM"
        case day = "d"
        case time = "HH:mm"
    }
    
    func format(
        _ unixTime: Int,
        to format: DateFormat,
        with timeZoneOffset: Int = 0
    ) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        locale = Locale(identifier: "en_US")
        timeZone = TimeZone(secondsFromGMT: timeZoneOffset)
        dateFormat = format.rawValue
        
        return string(from: date)
    }
    
    func format(
        _ unixTime: Int,
        with timeZoneOffset: Int
    ) -> DayTime {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        locale = Locale(identifier: "en_US")
        timeZone = TimeZone(secondsFromGMT: timeZoneOffset)
        
        let timeInterval = date
            .timeIntervalSince(
                date.startOfDay(offset: timeZoneOffset)
            ) / 3600
        
        if timeInterval < 4.0 || timeInterval >= 23 {
            return .night
        } else if timeInterval >= 4.0 && timeInterval < 12.0 {
            return .morning
        } else if timeInterval >= 12.0 && timeInterval < 17.0 {
            return .day
        } else if timeInterval >= 17.0 && timeInterval < 23.0 {
            return .evening
        } else {
            return .day
        }
    }
    
    func getHour(from unixTime: Int) -> Int {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        return calendar.component(.hour, from: date)
    }
}
