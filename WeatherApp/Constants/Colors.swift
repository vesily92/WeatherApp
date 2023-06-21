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
