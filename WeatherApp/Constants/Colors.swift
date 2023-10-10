//
//  Colors.swift
//  WeatherApp
//
//  Created by Василий Пронин on 17.05.2023.
//

import UIKit

enum Color {
    case main
    case translucent70
    case translucent50
    case translucent30
    case translucent20
}

extension Color {
    var white: UIColor {
        switch self {
        case .main: return .white
        case .translucent70: return .white.withAlphaComponent(0.7)
        case .translucent50: return .white.withAlphaComponent(0.5)
        case .translucent30: return .white.withAlphaComponent(0.3)
        case .translucent20: return .white.withAlphaComponent(0.2)
        }
    }
    
    var black: UIColor {
        switch self {
        case .main: return .black
        case .translucent70: return .black.withAlphaComponent(0.7)
        case .translucent50: return .black.withAlphaComponent(0.5)
        case .translucent30: return .black.withAlphaComponent(0.3)
        case .translucent20: return .black.withAlphaComponent(0.2)
        }
    }
    
    var teal: UIColor {
        switch self {
        case .main: return .systemTeal
        case .translucent70: return .systemTeal.withAlphaComponent(0.7)
        case .translucent50: return .systemTeal.withAlphaComponent(0.5)
        case .translucent30: return .systemTeal.withAlphaComponent(0.3)
        case .translucent20: return .systemTeal.withAlphaComponent(0.2)
        }
    }
    
    var clear: UIColor {
        return .clear
    }
}

enum BackgroundGradientColor {
    
    case clear(Position)
    case cloudy(Position)
    
    enum Position {
        case top
        case bottom
    }
}

extension BackgroundGradientColor {
    
    var night: UIColor {
        switch self {
        case .clear(.top): return UIColor(
            hue: 0.66,
            saturation: 0.8,
            brightness: 0.1,
            alpha: 1.0
        )
        case .clear(.bottom): return UIColor(
            hue: 0.62,
            saturation: 0.5,
            brightness: 0.33,
            alpha: 1.0
        )
            
        case .cloudy(.top): return UIColor(
            hue: 0.61,
            saturation: 0.45,
            brightness: 0.17,
            alpha: 1.0
        )
        case .cloudy(.bottom): return UIColor(
            hue: 0.63,
            saturation: 0.3,
            brightness: 0.2,
            alpha: 1.0
        )
        }
    }
    
    var sunrise: UIColor {
        switch self {
        case .clear(.top): return UIColor(
            hue: 0.62,
            saturation: 0.6,
            brightness: 0.42,
            alpha: 1.0
        )
        case .clear(.bottom): return UIColor(
            hue: 0.95,
            saturation: 0.35,
            brightness: 0.66,
            alpha: 1.0
        )
            
        case .cloudy(.top): return UIColor(
            hue: 0.6,
            saturation: 0.33,
            brightness: 0.55,
            alpha: 1.0
        )
        case .cloudy(.bottom): return UIColor(
            hue: 0.6,
            saturation: 0.16,
            brightness: 0.5,
            alpha: 1.0
        )
        }
    }
    
    var day: UIColor {
        switch self {
        case .clear(.top): return UIColor(
            hue: 0.6,
            saturation: 0.6,
            brightness: 0.6,
            alpha: 1.0
        )
        case .clear(.bottom): return UIColor(
            hue: 0.6,
            saturation: 0.4,
            brightness: 0.85,
            alpha: 1.0
        )
            
        case .cloudy(.top): return UIColor(
            hue: 0.61,
            saturation: 0.16,
            brightness: 0.55,
            alpha: 1.0
        )
        case .cloudy(.bottom): return UIColor(
            hue: 0.61,
            saturation: 0.17,
            brightness: 0.43,
            alpha: 1.0
        )
        }
    }
    
    var sunset: UIColor {
        switch self {
        case .clear(.top): return UIColor(
            hue: 0.62,
            saturation: 0.6,
            brightness: 0.42,
            alpha: 1.0
        )
        case .clear(.bottom): return UIColor(
            hue: 0.05,
            saturation: 0.34,
            brightness: 0.65,
            alpha: 1.0
        )
            
        case .cloudy(.top): return UIColor(
            hue: 0.6,
            saturation: 0.33,
            brightness: 0.55,
            alpha: 1.0
        )
        case .cloudy(.bottom): return UIColor(
            hue: 0.6,
            saturation: 0.16,
            brightness: 0.5,
            alpha: 1.0
        )
        }
    }
}
