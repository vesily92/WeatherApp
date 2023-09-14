//
//  ListSectionConfigurator.swift
//  WeatherApp
//
//  Created by Василий Пронин on 04.04.2023.
//

import UIKit

protocol IListSectionConfiguratorDelegate: AnyObject {
    func didRemoveCell(for item: AnyHashable, at index: Int)
}

final class ListSectionConfigurator {
    
    var type: SectionType.SearchScreen
    weak var delegate: IListSectionConfiguratorDelegate?
    
    private var items: [AnyHashable]
    
    init(type: SectionType.SearchScreen, items: [AnyHashable]) {
        self.type = type
        self.items = items
    }
    
    private func deleteItem(_ item: WeatherModel.ViewModel.Current) {
        guard let currentItems = items as? [WeatherModel.ViewModel.Current] else { return }

        if let index = currentItems.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
            
            delegate?.didRemoveCell(for: item, at: index)
        }
    }
    
    private func trailingSwipeActionsConfiguration(
        for indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if indexPath.item != 0 {
            guard indexPath.item < items.count,
                  let item = items[indexPath.item] as? WeatherModel.ViewModel.Current else {
                return nil
            }
            
            let configuration = UISwipeActionsConfiguration(
                actions: [deleteAction(item)]
            )
            return configuration
        }
        return nil
    }
    
    private func deleteAction(
        _ item: WeatherModel.ViewModel.Current
    ) -> UIContextualAction {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil
        ) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.deleteItem(item)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return deleteAction
    }
}

extension ListSectionConfigurator: ISectionConfigurator {
    func register(for collectionView: UICollectionView) {
        collectionView.register(cell: ListCell.self)
    }
    
    func cell(
        for item: AnyHashable,
        at indexPath: IndexPath,
        in collectionView: UICollectionView
    ) -> UICollectionViewCell? {
        
        guard let item = item as? WeatherModel.ViewModel.Current,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCell.reuseIdentifier,
                for: indexPath
              ) as? ListCell else { return nil }
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColorTransformer = UIConfigurationColorTransformer { [weak cell] _ in
            if let state = cell?.configurationState {
                if state.isSelected || state.isHighlighted {
                    return .clear
                }
            }
            return .clear
        }
        if indexPath.item != 0 {
            let accessories: [UICellAccessory] = [
                .delete(displayed: .whenEditing) { [weak self] in
                    self?.deleteItem(item)
                },
                .reorder(
                    displayed: .whenEditing,
                    options: .init(tintColor: .white)
                )
            ]
            cell.accessories = accessories
        }
        cell.backgroundConfiguration = backgroundConfig
        cell.configure(with: item)
        
        return cell
    }
    
    func supplementaryView(
        kind: String,
        for item: AnyHashable?,
        at indexPath: IndexPath,
        in collection: UICollectionView
    ) -> UICollectionReusableView? { nil }
    
    func layout(
        environment: NSCollectionLayoutEnvironment,
        collectionView: UICollectionView
    ) -> NSCollectionLayoutSection? {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.backgroundColor = .clear
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            return self?.trailingSwipeActionsConfiguration(for: indexPath)
        }
        let section = NSCollectionLayoutSection.list(
            using: configuration,
            layoutEnvironment: environment
        )
        section.interGroupSpacing = 10
        return section
    }
    
    func didSelect(at indexPath: IndexPath) {}
    
    func itemsForSection() -> [AnyHashable] { items }
    
    func itemForCell(at indexPath: IndexPath) -> AnyHashable? {
        items[indexPath.item]
    }
}
