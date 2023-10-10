//
//  WeatherViewModels.swift
//  WeatherApp
//
//  Created by Василий Пронин on 29.03.2023.
//

import Foundation

enum WeatherModel {
    
    struct Response {
        
        let weather: WeatherData
    }
    
    struct ViewModel: Hashable {
        
        let location: Location
        let list: Components.Current
        let current: Components.Current
        let hourly: [Components.Hourly]
        let daily: [Components.DailyCollection]
        let conditions: [Components.Conditions]
        let alert: [Components.Alert]?
        
        let sections: [Section]?
    }
    
    enum Components {
        
        struct Current: Hashable {
            
            let id = UUID()
            
            let backgroundColor: BackgroundColor?
            let cityName: String?
            let fullName: String?
            let description: String?
            let temperature: String?
            let temperatureRange: String?
            let time: String?
            
            var compactInfo: String? {
                guard let temperature = temperature,
                      let description = description else {
                    return nil
                }
                return "\(temperature) | \(description)"
            }
        }
        
        struct Alert: Hashable {
            
            let id = UUID()
            
            let sender: String?
            let event: String
            let description: String
        }
        
        struct Hourly: Hashable {
            
            enum CellType {
                case hourly
                case daily
            }
            
            let id = UUID()
            
            let cellType: CellType
            let unixTime: Int
            
            let time: String
            let symbolName: String
            let temperature: String?
            let event: String?
            let pop: String?
        }
        
        struct Daily: Hashable {
            
            let id = UUID()
            
            let time: String
            let minTemperature: String
            let maxTemperature: String
            let symbolName: String
            let indicatorViewModel: IndicatorViewModel
            let pop: String?
        }
        
        struct IndicatorViewModel: Hashable {
            
            let id = UUID()
            
            let startPoint: CGFloat
            let endPoint: CGFloat
            let currentPoint: CGFloat?
            let minTemperature: Int
            let maxTemperature: Int
        }
        
        struct BackgroundColor: Hashable {
            
            let id = UUID()
            
            let currentPosition: Double
            let sunrisePosition: Double
            let sunsetPosition: Double
            let cloudy: Bool
        }
        
        struct DailyCollection: Hashable {
            
            let id = UUID()
            let items: [Daily]
        }
        
        struct Conditions: Hashable {
            
            enum MetricsType {
                case uvIndex
                case sunrise
                case sunset
                case wind
                case precipitation
                case rainfall
                case feelsLike
                case humidity
                case visibility
                case pressure
            }
            
            let id = UUID()
            
            let type: MetricsType
            let uvIndex: UVIndex?
            let sunState: SunState?
            let wind: Wind?
            let precipitation: Precipitation?
            let feelsLike: FeelsLike?
            let humidity: Humidity?
            let visibility: Visibility?
            let pressure: Pressure?
            
            init(type: MetricsType,
                 uvIndex: UVIndex? = nil,
                 sunState: SunState? = nil,
                 wind: Wind? =  nil,
                 precipitation: Precipitation? = nil,
                 feelsLike: FeelsLike? = nil,
                 humidity: Humidity? = nil,
                 visibility: Visibility? = nil,
                 pressure: Pressure? = nil) {
                self.type = type
                self.uvIndex = uvIndex
                self.sunState = sunState
                self.wind = wind
                self.precipitation = precipitation
                self.feelsLike = feelsLike
                self.humidity = humidity
                self.visibility = visibility
                self.pressure = pressure
            }
        }
        
        struct UVIndex: Hashable {
            
            let id = UUID()
            
            let index: String
            let description: String
            let currentPoint: CGFloat
            let recommendation: String
        }
        
        struct SunState: Hashable {
            
            let id = UUID()
            
            let time: String
            let nextEvent: String
            let progress: Double
            let isSunrise: Bool
        }
        
        struct Wind: Hashable {
            
            let id = UUID()
            
            let speed: String
            let degrees: Int
        }
        
        struct Precipitation: Hashable {
            
            let id = UUID()
            
            let pop: String
            let expectation: String
            let isRainfall: Bool
        }
        
        struct FeelsLike: Hashable {
            
            let id = UUID()
            
            let temperature: String
            let description: String
        }
        
        struct Humidity: Hashable {
            
            let id = UUID()
            
            let humidity: String
            let description: String
        }
        
        struct Visibility: Hashable {
            
            let id = UUID()
            
            let distance: String
            let description: String
        }
        
        struct Pressure: Hashable {
            
            enum State {
                case rising
                case falling
                case stable
            }
            
            let id = UUID()
            
            let state: State
            let pressure: String
            let rotationDegrees: Double
        }
    }
}

extension WeatherModel.Components.Conditions.MetricsType {
    
    var title: String {
        switch self {
        case .uvIndex: return "UV INDEX"
        case .sunrise: return "SUNRISE"
        case .sunset: return "SUNSET"
        case .wind: return "WIND"
        case .precipitation: return "PRECIPITATION"
        case .rainfall: return "RAINFALL"
        case .feelsLike: return "FEELS LIKE"
        case .humidity: return "HUMIDITY"
        case .visibility: return "VISIBILITY"
        case .pressure: return "PRESSURE"
        }
    }
    
    var symbolName: String {
        switch self {
        case .uvIndex: return Symbol.Condition.uvIndex.rawValue
        case .sunrise: return Symbol.Condition.sunrise.rawValue
        case .sunset: return Symbol.Condition.sunset.rawValue
        case .wind: return Symbol.Condition.wind.rawValue
        case .precipitation: return Symbol.Condition.precipitation.rawValue
        case .rainfall: return Symbol.Condition.precipitation.rawValue
        case .feelsLike: return Symbol.Condition.feelsLike.rawValue
        case .humidity: return Symbol.Condition.humidity.rawValue
        case .visibility: return Symbol.Condition.visibility.rawValue
        case .pressure: return Symbol.Condition.pressure.rawValue
        }
    }
}
