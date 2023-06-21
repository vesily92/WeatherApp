//
//  SectionService.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

/// A type that creates sections for collection view on ``WeatherViewController``.
protocol IWeatherScreenSectionService {
    
    /// Creates view model from data.
    /// - Parameter data: The data object.
    /// - Returns: View model.
    func setupCurrentWith(
        data: WeatherModel.Data
    ) -> WeatherModel.ViewModel.Current
    
    /// Creates sections for collection view on ``WeatherViewController``.
    /// - Parameters:
    ///   - sectionTypes: Types of sections that must be configured.
    ///   - data: The data object for items of cells in sections.
    /// - Returns: Configured sections.
    func createWeatherSections(
        for sectionTypes: [SectionType.WeatherScreen],
        with data: WeatherModel.Data
    ) -> [Section]}

/// A type that  creates sections for collection view on ``SearchViewController``.
protocol ISearchScreenSectionService {
    
    /// Creates sections for collection view. ``SearchViewController``.
    /// - Parameters:
    ///   - sectionTypes: Types of sections that must be configured.
    ///   - data: The array of data objects for items of cells in sections.
    ///   - delegate: The object that acts like delegate of ``ListSectionConfigurator``.
    /// - Returns: Configured sections.
    func createSearchSections(
        for sectionTypes: [SectionType.SearchScreen],
        with data: [WeatherModel.Data],
        delegate: IListSectionConfiguratorDelegate
    ) -> [Section]
}

// MARK: - SectionService
/// The service object that create sections for collection views.
final class SectionService {
    static let shared = SectionService()
    
    private let dateFormatter = DateFormatter()
    private let weatherFormatter = WeatherFormatter()

    private init() {}
}

// MARK: - SectionService + IWeatherScreenSectionService
extension SectionService: IWeatherScreenSectionService {
    func setupCurrentWith(
        data: WeatherModel.Data
    ) -> WeatherModel.ViewModel.Current {
        return CurrentMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(data.weather, location: data.location)
    }
    
    func createWeatherSections(
        for sectionTypes: [SectionType.WeatherScreen],
        with data: WeatherModel.Data
    ) -> [Section] {
        
        var sections: [Section] = []
        sectionTypes.forEach { sectionType in
            let sectionConfigurator = configureSection(
                for: sectionType,
                with: data
            )
            sections.append(Section(section: sectionConfigurator))
        }
        
        return sections
    }
    
    /// Configures section for provided section type.
    /// - Parameters:
    ///   - sectionType: Type of the section that must be configured.
    ///   - data: The array of data objects for items of cells in sections.
    /// - Returns: Configured section.
    private func configureSection(
        for sectionType: SectionType.WeatherScreen,
        with data: WeatherModel.Data
    ) -> ISectionConfigurator {
        
        let items = createItems(
            for: sectionType,
            with: data
        )
        
        switch sectionType {
        case .alert:
            return AlertSectionConfigurator(type: sectionType, items: items)
        case .hourly:
            return HourlySectionConfigurator(type: sectionType, items: items)
        case .daily:
            return DailySectionConfigurator(type: sectionType, items: items)
        case .conditions:
            return ConditionsSectionConfigurator(type: sectionType, items: items)
        case .footer:
            return FooterSectionConfigurator(type: sectionType, items: items)
        }
    }
    
    /// Creates items for cells in section.
    /// - Parameters:
    ///   - sectionType: Type of the section for which items must be created.
    ///   - data: The data for items of cells in section.
    /// - Returns: Items for cells in section.
    private func createItems(
        for sectionType: SectionType.WeatherScreen,
        with data: WeatherModel.Data
    ) -> [AnyHashable] {
        
        guard let weather = data.weather else { return [] }
                
                
        switch sectionType {
        case .alert:
            return AlertMapper().map(weather)
        case .hourly:
            return HourlyMapper(
                dateFormatter: dateFormatter,
                weatherFormatter: weatherFormatter
            ).map(weather)
        case .daily:
            return DailyCollectionMapper(
                dateFormatter: dateFormatter,
                weatherFormatter: weatherFormatter
            ).map(weather)
        case .conditions:
            return ConditionsMapper(
                dateFormatter: dateFormatter,
                weatherFormatter: weatherFormatter
            ).map(weather)
        case .footer:
            let item = CurrentMapper(
                dateFormatter: dateFormatter,
                weatherFormatter: weatherFormatter
            ).map(nil, location: data.location)
            return [item]
        }
    }
}

// MARK: - SectionService + ISearchScreenSectionService
extension SectionService: ISearchScreenSectionService {
    func createSearchSections(
        for sectionTypes: [SectionType.SearchScreen],
        with data: [WeatherModel.Data],
        delegate: IListSectionConfiguratorDelegate
    ) -> [Section] {
        var sections: [Section] = []
        
        sectionTypes.forEach { sectionType in
            let sectionConfigurator = configureSearchScreenSection(
                for: sectionType,
                data: data,
                delegate: delegate
            )
            sections.append(Section(section: sectionConfigurator))
        }
        
        return sections
    }
    
    /// Configures section for provided section type.
    /// - Parameters:
    ///   - sectionType: Type of the section that must be configured.
    ///   - data: The data received from network call.
    ///   - delegate: The object that acts like delegate of ``ListSectionConfigurator``.
    /// - Returns: Configured section.
    private func configureSearchScreenSection(
        for sectionType: SectionType.SearchScreen,
        data: [WeatherModel.Data],
        delegate: IListSectionConfiguratorDelegate
    ) -> ISectionConfigurator {
        
        let items = createSearchScreenItems(
            for: sectionType,
            data: data
        )
        
        switch sectionType {
        case .list:
            let configurator = ListSectionConfigurator(
                type: sectionType,
                items: items
            )
            configurator.delegate = delegate
            return configurator
        }
    }
    
    /// Creates items for cells in section.
    /// - Parameters:
    ///   - sectionType: Type of the section for which items must be created.
    ///   - data: The data received from network call.
    /// - Returns: Items for cells in section.
    private func createSearchScreenItems(
        for sectionType: SectionType.SearchScreen,
        data: [WeatherModel.Data]
    ) -> [AnyHashable] {
        switch sectionType {
        case .list:
            return ListMapper(
                dateFormatter: dateFormatter,
                weatherFormatter: weatherFormatter
            ).map(data)
        }
    }
}
