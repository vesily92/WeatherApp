//
//  DailySectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 16.05.2023.
//

import UIKit

final class DailySectionConfigurator: BaseSectionConfigurator, ISectionConfigurator {
    
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: DailyCollectionCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        guard let item = item as? WeatherModel.Components.DailyCollection else {
            return nil
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DailyCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? DailyCollectionCell else { return nil }
        
        cell.configure(with: item)
        return cell
    }
    
    func supplementaryView(
        kind: String,
        for item: AnyHashable?,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionReusableView? {
        
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: SectionHeader.reuseIdentifier,
            withReuseIdentifier: SectionHeader.reuseIdentifier,
            for: indexPath
        ) as? SectionHeader else {
            return nil
        }
        
        sectionHeader.configure(with: .daily)
        
        return sectionHeader
    }
    
    func layout(
        environment: NSCollectionLayoutEnvironment,
        collectionView: UICollectionView
    ) -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(350)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader()]
        section.decorationItems = [decorationView()]
        
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, env in
            items.forEach { item in
                guard let cell = collectionView.cellForItem(
                    at: item.indexPath
                ) as? BaseCell else {
                    return
                }
                
                self?.maskCells(
                    item: item,
                    offset: offset,
                    collectionView: collectionView,
                    cell: cell
                )
                self?.animateHeader(
                    item: item,
                    offset: offset,
                    collectionView: collectionView,
                    cell: cell
                )
            }
        }
        return section
    }
    
    func didSelect(at indexPath: IndexPath) {}
}
