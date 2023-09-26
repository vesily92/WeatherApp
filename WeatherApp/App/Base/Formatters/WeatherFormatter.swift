//
//  WeatherFormatter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

/// A type that provides formatted weather data.
protocol IWeatherFormatter {
    
    /// Gets temperature data ready for displaying.
    /// - Parameter temperature: Temperature value.
    /// - Returns: String representation.
    func displayTemperature(_ temperature: Double) -> String
    
    /// Gets UVI data ready for displaying.
    /// - Parameter uvi: UVI value.
    /// - Returns: String representation.
    func displayUVI(_ uvi: Double) -> String
    
    /// Gets UVI description data ready for displaying.
    /// - Parameter uvi: UVI description value.
    /// - Returns: String representation.
    func displayUVIDescription(_ uvi: Double) -> String
    
    /// Gets weather description data ready for displaying.
    /// - Parameter description: Weather description value.
    /// - Returns: String representation.
    func displayDescription(_ description: String) -> String
    
    /// Gets precipitation data ready for displaying.
    /// - Parameter precipitation: Precipitation value.
    /// - Returns: String representation.
    func displayPrecipitation(_ precipitation: Double) -> String
    
    /// Gets probability of precipitation data ready for displaying.
    /// - Parameters:
    ///   - pop: Probability of precipitation value.
    ///   - weatherID: ID of weather condition.
    /// - Returns: String representation.
    func displayPop(_ pop: Double, weatherID: Int) -> String?
    
    /// Gets pressure data ready for displaying.
    /// - Parameter pressure: Pressure value.
    /// - Returns: String representation.
    func displayPressure(_ pressure: Int) -> String
    
    /// Verifies if it's a day time.
    /// - Parameter iconName: Name of the weather icon.
    /// - Returns: A Boolean value indicating whether the sun is up.
    func sunIsUp(_ iconName: String) -> Bool
    
    /// Gets the SF symbol name.
    /// - Parameters:
    ///   - weatherID: ID of weather condition.
    ///   - icon: Name of the weather icon.
    /// - Returns: String representation.
    func getWeatherSymbolName(_ weatherID: Int, icon: String) -> String
    
    /// Gets the type of background gradient
    /// - Parameters:
    ///   - weatherID: ID of weather condition.
    ///   - dayTime: Type of day time.
    /// - Returns: Type of gradient color based on day time.
    func getBackgroundColor(_ weatherID: Int, dayTime: DayTime) -> BackgroundType
}

// MARK: - WeatherFormatter + IWeatherFormatter

/// Weather formatter object.
final class WeatherFormatter: IWeatherFormatter {
    
    func displayTemperature(_ temperature: Double) -> String {
        String(format: "%.0f", temperature.roundDecimal()) + "°"
    }
    
    func displayUVI(_ uvi: Double) -> String {
        String(format: "%.0f", uvi.roundDecimal())
    }
    
    func displayDescription(_ description: String) -> String {
        description.capitalized
    }
    
    func displayPrecipitation(_ precipitation: Double) -> String {
        String(format: "%.0f", precipitation.roundDecimal()) + " mm"
    }
    
    func displayPop(_ pop: Double, weatherID: Int) -> String? {
        var isNeeded: Bool {
            switch weatherID {
            case 200...232: return true
            case 300...321: return true
            case 500...531: return true
            case 600...622: return true
            default: return false
            }
        }
        
        if !isNeeded {
            return nil
        } else if pop <= 0.1 {
            return nil
        } else {
            let roundedValue = pop.roundDecimal(1)
            return String(format: "%.0f",roundedValue * 100) + " %"
        }
    }
    
    func displayUVIDescription(_ uvi: Double) -> String {
        switch uvi {
        case 0...2: return "Low"
        case 3...5: return "Moderate"
        case 6...8: return "High"
        case 9...10: return "Very High"
        default: return ""
        }
    }
    
    func displayPressure(_ pressure: Int) -> String {
        let newValue = Double(pressure) / 1.33322387415
        return String(format: "%.0f", newValue.rounded())
    }
    
    func sunIsUp(_ iconName: String) -> Bool {
        if iconName.hasSuffix("d") {
            return true
        }
        return false
    }
    
    func getWeatherSymbolName(_ weatherID: Int, icon: String) -> String {
        var sunIsUp: Bool {
            icon.hasSuffix("d")
        }
        
        switch weatherID {
        case 200...232: return Symbol.Weather.bolt.rawValue
        case 300...321: return Symbol.Weather.drizzle.rawValue
        case 500...531: return Symbol.Weather.heavyRain.rawValue
        case 600...622: return Symbol.Weather.snow.rawValue
        case 700...781: return Symbol.Weather.fog.rawValue
        case 800: return sunIsUp
            ? Symbol.Weather.sun.rawValue
            : Symbol.Weather.moon.rawValue
        case 801: return sunIsUp
            ? Symbol.Weather.cloudDay.rawValue
            : Symbol.Weather.cloudNight.rawValue
        case 802...804: return Symbol.Weather.cloud.rawValue
        default: return Symbol.Other.noSign.rawValue
        }
    }
    
    func getBackgroundColor(
        _ weatherID: Int,
        dayTime: DayTime
    ) -> BackgroundType {
        enum Weather {
            case clear
            case cloudy
        }
        
        var weather: Weather = .clear
        
        switch weatherID {
        case 200...232: weather = .cloudy
        case 300...321: weather = .cloudy
        case 500...531: weather = .cloudy
        case 600...622: weather = .cloudy
        case 700...781: weather = .cloudy
        case 800...801: weather = .clear
        case 802...804: weather = .cloudy
        default: weather = .clear
        }
        
        switch weather {
        case .clear:
            switch dayTime {
            case .morning:
                return .morningClear
            case .day:
                return .dayClear
            case .evening:
                return .eveningClear
            case .night:
                return .nightClear
            }
        case .cloudy:
            switch dayTime {
            case .morning:
                return .morningClouds
            case .day:
                return .dayClouds
            case .evening:
                return .eveningClouds
            case .night:
                return .nightClouds
            }
        }
    }
}
