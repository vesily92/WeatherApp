//
//  DateFormatter + Extension.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

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
}
