//
//  SpacerSectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 10.07.2023.
//

import UIKit

final class SpacerSectionConfigurator: ISectionConfigurator {
    
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: EmptyCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmptyCell.reuseIdentifier,
            for: indexPath
        ) as? EmptyCell else { return nil }
        
        return cell
    }
    
    func supplementaryView(
        kind: String,
        for item: AnyHashable?,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionReusableView? { nil }
    
    func layout(
        environment: NSCollectionLayoutEnvironment,
        collectionView: UICollectionView
    ) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(
                Size.currentWeatherViewMaxHeight - Size.currentWeatherViewMinHeight
            )
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func didSelect(at indexPath: IndexPath) {}
    
    func didReorder(items: [AnyHashable]) {}
    
    func itemForCell(at indexPath: IndexPath) -> AnyHashable? { nil }
}
