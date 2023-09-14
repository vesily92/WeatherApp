//
//  DailyCollectionCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 16.05.2023.
//

import UIKit

final class DailyCollectionCell: BaseCell {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, AnyHashable>
    
    private var dataSource: DataSource?
    private var collectionView: UICollectionView!
    private var items: [WeatherModel.Components.Daily] = [] {
        didSet { makeSnapshot() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        createDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WeatherModel.Components.DailyCollection) {
        items = model.items
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isScrollEnabled = false
        contentView.addSubview(collectionView)
        
        collectionView.register(cell: DailyCell.self)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _ , layoutEnvironment in
            let section: NSCollectionLayoutSection
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.separatorConfiguration.topSeparatorVisibility = .hidden
            configuration.separatorConfiguration.bottomSeparatorVisibility = .hidden
            configuration.backgroundColor = .clear
            
            section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
            return section
        }
        return layout
    }
    
    private func createDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [unowned self] collectionView, indexPath, itemIdentifier in
                return self.cell(
                    collectionView: collectionView,
                    indexPath: indexPath,
                    item: itemIdentifier
                )
            }
        )
    }
    
    private func cell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        item: AnyHashable
    ) -> UICollectionViewCell? {
        guard let item = item as? WeatherModel.Components.Daily,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyCell.reuseIdentifier,
                for: indexPath
              ) as? DailyCell else { return nil }
        
        cell.configure(with: item)
        return cell
    }
    
    private func makeSnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
