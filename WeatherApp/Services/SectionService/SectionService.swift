//
//  SectionService.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

/// A type that creates sections for collection view on ``WeatherViewController``.
protocol IWeatherScreenSectionService {
    
    /// Creates sections for collection view on ``WeatherViewController``.
    /// - Parameters:
    ///   - sectionTypes: Types of sections that must be configured.
    ///   - data: The data object for items of cells in sections.
    /// - Returns: Configured sections.
    func createWeatherSections(
        for sectionTypes: [SectionType.WeatherScreen]
    ) -> [Section]
}

// MARK: - SectionService

/// The service object that create sections for collection views.
final class SectionService {
    
    static let shared = SectionService()
    
    private init() {}
    
    /// Configures section for provided section type.
    /// - Parameters:
    ///   - sectionType: Type of the section that must be configured.
    ///   - data: The array of data objects for items of cells in sections.
    /// - Returns: Configured section.
    private func configureSection(
        for sectionType: SectionType.WeatherScreen
    ) -> ISectionConfigurator {
        
        switch sectionType {
        case .spacer:
            return SpacerSectionConfigurator()
        case .alert:
            return AlertSectionConfigurator()
        case .hourly:
            return HourlySectionConfigurator()
        case .daily:
            return DailySectionConfigurator()
        case .conditions:
            return ConditionsSectionConfigurator()
        case .footer:
            return FooterSectionConfigurator()
        }
    }
}

// MARK: - SectionService + IWeatherScreenSectionService

extension SectionService: IWeatherScreenSectionService {
    
    func createWeatherSections(
        for sectionTypes: [SectionType.WeatherScreen]
    ) -> [Section] {
        var sections: [Section] = []
        
        sectionTypes.forEach { sectionType in
            let sectionConfigurator = configureSection(
                for: sectionType
            )
            sections.append(
                Section(
                    section: sectionConfigurator,
                    type: sectionType
                )
            )
        }
        
        return sections
    }
}
