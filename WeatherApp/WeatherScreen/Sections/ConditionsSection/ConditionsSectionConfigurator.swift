//
//  ConditionsSectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class ConditionsSectionConfigurator: BaseSectionConfigurator, ISectionConfigurator {
    var onCellSelected: ((IndexPath) -> Void)?
    
    var type: SectionType.WeatherScreen
    
    private var items: [AnyHashable]
    
    init(type: SectionType.WeatherScreen, items: [AnyHashable]) {
        self.type = type
        self.items = items
    }
    
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: ConditionCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        guard let item = item as? WeatherModel.ViewModel.Conditions else {
            return nil
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ConditionCell.reuseIdentifier,
            for: indexPath
        ) as? ConditionCell else { return nil }
        
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

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 10,
            trailing: 0
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )

        let leftGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let rightGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        leftGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 5
        )
        rightGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 5,
            bottom: 0,
            trailing: 0
        )

        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitems: [leftGroup, rightGroup]
        )

        let section = NSCollectionLayoutSection(group: group)
        
        section.visibleItemsInvalidationHandler = { items, offset, env in
            items.forEach { item in

                guard let cell = collectionView.cellForItem(at: item.indexPath) as? ConditionCell else {
                    return
                }

                let headerHeight = CGFloat(Size.headerHeight)
                let hiddenFrameHeight = offset.y + headerHeight - cell.frame.origin.y

                if hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height {
                    cell.setMask(with: hiddenFrameHeight)
                }

                if offset.y >= cell.frame.maxY - headerHeight {
                    let alpha = 1 - ((offset.y - (cell.frame.maxY - headerHeight)) / 30)
                    cell.setAlphaForHeader(with: alpha)
                    cell.removeBlur()
                } else {
                    cell.setAlphaForHeader(with: 1)
                    cell.setBlur()
                }
                if offset.y >= cell.frame.minY {
                    cell.setHeaderMask(with: offset.y - cell.frame.minY)
                    cell.setHeaderOffset(with: offset.y - cell.frame.minY)
                } else {
                    cell.setHeaderMask(with: 0)
                    cell.setHeaderOffset(with: 0)
                }
            }
        }
        
        return section
    }
    
    func didSelect(at indexPath: IndexPath) {}
    
    func itemsForSection() -> [AnyHashable] { items }
    
    func itemForCell(at indexPath: IndexPath) -> AnyHashable? { nil }
}
