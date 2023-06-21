//
//  ListScreenSectionManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 07.06.2023.
//

import Foundation

/// A type that provides configured sections for collection view on ``SearchViewController``.
protocol ISearchScreenSectionManager {
    
    /// Provides configured sections for collection view on ``SearchViewController``.
    /// - Parameters:
    ///   - data: The data received from network call.
    ///   - delegate: The object that acts like delegate of ``ListSectionConfigurator``.
    /// - Returns: Array of configured sections.
    func createSections(
        with data: [WeatherModel.Data],
        delegate: IListSectionConfiguratorDelegate
    ) -> [Section]
}

// MARK: - SearchScreenSectionManager
/// Manager that provides sections for collection view on ``SearchViewController``.
final class SearchScreenSectionManager {
    
    let sectionService: ISearchScreenSectionService
    
    init(sectionService: ISearchScreenSectionService) {
        self.sectionService = sectionService
    }
}

// MARK: - SearchScreenSectionManager + ISearchScreenSectionManager
extension SearchScreenSectionManager: ISearchScreenSectionManager {
    func createSections(
        with data: [WeatherModel.Data],
        delegate: IListSectionConfiguratorDelegate
    ) -> [Section] {
        return sectionService.createSearchSections(
            for: [.list],
            with: data,
            delegate: delegate
        )
    }
}
