//
//  HourlySectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class HourlySectionConfigurator: BaseSectionConfigurator, ISectionConfigurator {
    var onCellSelected: ((IndexPath) -> Void)?
    
    var type: SectionType.WeatherScreen
    
//    private lazy var cellRegister = UICollectionView.CellRegistration<HourlyCell, WeatherModel.ViewModel.Hourly> { cell, indexPath, model in
//
//        cell.configure(with: model)
//    }
    
    private var items: [AnyHashable]
    
    init(type: SectionType.WeatherScreen, items: [AnyHashable]) {
        self.type = type
        self.items = items
    }
    
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: HourlyCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        
        guard let item = item as? WeatherModel.ViewModel.Hourly,
              let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyCell.reuseIdentifier,
            for: indexPath
        ) as? HourlyCell else { return nil }
        
        cell.configure(with: item)
        return cell
        
//        guard let item = item as? WeatherModel.ViewModel.Hourly else {
//            return nil
//        }
//
//        return collectionView.dequeueConfiguredReusableCell(
//            using: cellRegister,
//            for: indexPath,
//            item: item
//        )
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
        
        sectionHeader.configure(with: type)
        
        return sectionHeader
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
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(70),
            heightDimension: .absolute(100.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [sectionHeader()]
        section.decorationItems = [decorationView()]
                
        section.visibleItemsInvalidationHandler = { [weak self] items, offset, env in
            items.forEach { item in
                guard let cell = collectionView.cellForItem(
                    at: item.indexPath
                ) as? BaseCell else {
                    return
                }
//                self?.maskCells(
//                    item: item,
//                    offset: offset,
//                    collectionView: collectionView,
//                    cell: cell
//                )
                
                let offsetY = collectionView.contentOffset.y
                let headerHeight = CGFloat(Size.headerHeight)
                let maskedFrame = offset.y - cell.frame.minY + headerHeight
                let reserveMaskedFrame = offsetY - cell.frame.minY + headerHeight
                
                if maskedFrame >= 0 || maskedFrame <= cell.frame.size.height {
                    if offsetY >= cell.frame.minY {
                        cell.makeMask(for: max(maskedFrame, reserveMaskedFrame))
                    } else {
                        cell.makeMask(for: min(maskedFrame, reserveMaskedFrame))
                    }
                }
                
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
    
    func itemsForSection() -> [AnyHashable] { items }
    
    func itemForCell(at indexPath: IndexPath) -> AnyHashable? { nil }
}
