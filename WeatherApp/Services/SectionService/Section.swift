//
//  WeatherScreenSection.swift
//  WeatherApp
//
//  Created by Василий Пронин on 06.04.2023.
//

import UIKit

/// A section of collection view which contains it's own configuration.
struct Section {
    
    let id: UUID
    private(set) var type: SectionType.WeatherScreen
    private(set) var section: ISectionConfigurator
    
    init(section: ISectionConfigurator,
         type: SectionType.WeatherScreen) {
        self.id = UUID()
        self.section = section
        self.type =  type
    }
}

// MARK: - Section + Hashable
extension Section: Hashable {
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - SectionType

/// Namespace for section types.
enum SectionType {
    
    /// Section types for collection view on WeatherScreen.
    enum WeatherScreen: CaseIterable {
        // Invisible section that works as spacer
        case spacer
        case alert
        case hourly
        case daily
        case conditions
        case footer
        
        /// Title for section header.
        var title: String {
            switch self {
            case .alert: return "WEATHER ALERT"
            case .hourly: return "HOURLY FORECAST"
            case .daily: return "8-DAY FORECAST"
            default: return ""
            }
        }
        
        /// Symbol name for section header.
        var symbolName: String {
            switch self {
            case .alert: return Symbol.Section.alert.rawValue
            case .hourly: return Symbol.Section.hourly.rawValue
            case .daily: return Symbol.Section.daily.rawValue
            default: return ""
            }
        }
    }
    
    /// Section types for collection view on Search Screen.
    enum SearchScreen: CaseIterable {
        case list
    }
}
