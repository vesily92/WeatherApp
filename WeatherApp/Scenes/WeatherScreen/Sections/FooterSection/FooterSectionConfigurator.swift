//
//  FooterSectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 02.06.2023.
//

import UIKit

final class FooterSectionConfigurator: ISectionConfigurator {
    
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: FooterCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        guard let item = item as? WeatherModel.Components.Current else {
            return nil
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FooterCell.reuseIdentifier,
            for: indexPath
        ) as? FooterCell else { return nil }
        
        cell.configure(with: item)
        return cell
    }
    
    func supplementaryView(
        kind: String,
        for item: AnyHashable?,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionReusableView? {
        nil
    }
    
    func layout(
        environment: NSCollectionLayoutEnvironment,
        collectionView: UICollectionView
    ) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
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
}
