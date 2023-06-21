//
//  AlertSectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class AlertSectionConfigurator: BaseSectionConfigurator, ISectionConfigurator {
    
    var onCellSelected: ((IndexPath) -> Void)?
    
    
//    private lazy var cellRegister = UICollectionView.CellRegistration<AlertCell, WeatherModel.ViewModel.Alert> { cell, indexPath, model in
//        cell.configure(with: model)
//    }
    
    
    
    var type: SectionType.WeatherScreen
    
    private var items: [AnyHashable]
    
    init(type: SectionType.WeatherScreen, items: [AnyHashable]) {
        self.type = type
        self.items = items
    }
    
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: AlertCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        guard let item = item as? WeatherModel.ViewModel.Alert else {
            return nil
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlertCell.reuseIdentifier,
            for: indexPath
        ) as? AlertCell else { return nil }

        cell.configure(with: item)
        return cell
        
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
    
    func itemsForSection() -> [AnyHashable] { items }
    
    func itemForCell(at indexPath: IndexPath) -> AnyHashable? { nil }
}
