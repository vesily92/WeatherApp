//
//  Symbols.swift
//  WeatherApp
//
//  Created by Василий Пронин on 02.06.2023.
//

import UIKit

enum Symbol {
    enum Weather: String {
        case sun = "sun.max.fill"
        case cloud = "cloud.sun.fill"
        case drizzle = "cloud.drizzle.fill"
        case heavyRain = "cloud.heavyrain.fill"
        case bolt = "cloud.bolt.rain.fill"
        case snow = "snowflake"
        case fog = "cloud.fog.fill"
        case moon = "moon.stars.fill"
        case cloudNight = "cloud.moon.fill"
        case sunrise = "sunrise.fill"
        case sunset = "sunset.fill"
    }
    
    enum Condition: String {
        case uvIndex = "sun.max.fill"
        case sunrise = "sunrise.fill"
        case sunset = "sunset.fill"
        case wind
        case precipitation = "drop.fill"
        case feelsLike = "thermometer.medium"
        case humidity
        case visibility = "eye.fill"
        case pressure = "gauge.medium"
    }
    
    enum Section: String {
        case alert = "exclamationmark.triangle.fill"
        case hourly = "clock"
        case daily = "calendar"
    }
    
    enum Other: String {
        case chevronRight = "chevron.right"
        case arrowUp = "arrow.up"
        case arrowDown = "arrow.down"
        case equal
        case map
        case magnifyingGlass = "magnifyingglass"
        case noSign = "nosign"
    }
}

extension Symbol.Weather {
    var image: UIImage? {
        UIImage(systemName: self.rawValue)?.withRenderingMode(.alwaysOriginal)
    }
}

extension Symbol.Condition {
    var image: UIImage? {
        UIImage(systemName: self.rawValue)
    }
}

extension Symbol.Other {
    var image: UIImage? {
        UIImage(systemName: self.rawValue)
    }
}
