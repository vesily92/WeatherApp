//
//  WeatherScreenSection.swift
//  WeatherApp
//
//  Created by Василий Пронин on 06.04.2023.
//

import UIKit

/// A type that provides section configuration.
protocol ISectionConfigurator {
    
    /// Register cell.
    /// - Parameter collectionView: Collection View object.
    func register(for collectionView: UICollectionView)
    
    /// Dequeues a reusable cell object.
    /// - Parameters:
    ///   - item: The item that provides data for the cell.
    ///   - indexPath: The index path that specifies the location of the cell in the collection view.
    ///   - collectionView: Collection view object.
    /// - Returns: Configured reusable cell object.
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell?
    
    
    /// Dequeues a reusable view object.
    /// - Parameters:
    ///   - kind: The kind of supplementary view to retrieve.
    ///   - item: The item that provides data for the view.
    ///   - indexPath: The index path specifying the location of the supplementary view in the collection view.
    ///   - collectionView: Collection view object.
    /// - Returns: Configured reusable view object.
    func supplementaryView(
        kind: String,
        for item: AnyHashable?,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionReusableView?
    
    
    /// Configures layout for section.
    /// - Parameters:
    ///   - environment: Layout’s container object.
    ///   - collectionView: Collection view object.
    /// - Returns: Configured section layout object.
    func layout(
        environment: NSCollectionLayoutEnvironment,
        collectionView: UICollectionView
    ) -> NSCollectionLayoutSection?
    
    /// Handles user interaction.
    /// - Parameter indexPath: The index path that specifies the location of the cell being interacted.
    func didSelect(at indexPath: IndexPath)
    
    /// Retrieves items.
    /// - Returns: Items that provide data for cells.
    func itemsForSection() -> [AnyHashable]
    
    /// Retrieves item for selected cell
    /// - Parameter indexPath: The index path that specifies the location of the cell being interacted.
    /// - Returns: Item that provide data for cell.
    func itemForCell(at indexPath: IndexPath) -> AnyHashable?
}

// MARK: - Section
/// A section of collection view which contains it's own configuration.
struct Section {
    let id: UUID
    private(set) var section: ISectionConfigurator
    
    init(section: ISectionConfigurator) {
        self.id = UUID()
        self.section = section
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
