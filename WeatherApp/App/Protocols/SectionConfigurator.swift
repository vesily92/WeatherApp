//
//  SectionConfigurator.swift
//  WeatherApp
//
//  Created by Vasilii Pronin on 15.09.2023.
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
}
