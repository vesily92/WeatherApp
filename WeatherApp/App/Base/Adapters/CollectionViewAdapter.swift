//
//  CollectionViewAdapter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

/// A type that notifies about scrolling events.
protocol IScrollDelegate: AnyObject {
    
    /// Notifies when scroll view did scroll.
    /// - Parameter scrollView: Scroll view object.
    func scrollViewDidScroll(scrollView: UIScrollView)
}

/// A type that receives the index path of the selected cell.
protocol ITouchesDelegate: AnyObject {
    
    /// Receives the index path of the selected cell.
    /// - Parameter indexPath: Index path of the cell.
    func cellSelected(at indexPath: IndexPath)
}

/// A type that provides configured sections to ``CollectionViewAdapter``.
protocol ICollectionViewAdapterDelegate: AnyObject {
    
    /// Provides configured sections.
    /// - Returns: An array of sections.
    func sectionsForCollectionView() -> [Section]
}

// MARK: - CollectionViewAdapter
final class CollectionViewAdapter: NSObject {
    
    // MARK: - Properties
    private weak var delegate: ICollectionViewAdapterDelegate?
    private weak var collectionView: UICollectionView?
    private weak var scrollDelegate: IScrollDelegate?
    private weak var touchesDelegate: ITouchesDelegate?
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable> = {
        guard let collectionView = collectionView else { fatalError() }
        
        return UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: cell
        )
    }()
    
    // MARK: - Initialisers
    init(delegate: ICollectionViewAdapterDelegate,
         collectionView: UICollectionView,
         scrollDelegate: IScrollDelegate? = nil,
         touchesDelegate: ITouchesDelegate? = nil) {
        self.delegate = delegate
        self.collectionView = collectionView
        self.scrollDelegate = scrollDelegate
        self.touchesDelegate = touchesDelegate
        super.init()
        
        collectionView.register(view: SectionHeader.self)
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.delegate = self
        dataSource.supplementaryViewProvider = supplementaryView
    }
    
    // MARK: - Internal Methods
    /// Creates and applies snapshot for collection view's data source.
    /// - Parameters:
    ///   - animated: Flag for the system to animate the updates to the collection view or not.
    ///   - completion: Closure to execute when the animations are complete.
    func makeSnapshot(animated: Bool, completion: (() -> Void)? = nil) {
        guard let delegate = delegate,
              let collectionView = collectionView else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        for section in delegate.sectionsForCollectionView() {
            section.section.register(for: collectionView)
            snapshot.appendSections([section])
            
            let items = section.section.itemsForSection()
            snapshot.appendItems(items)
        }

        dataSource.apply(snapshot)
    }
    
    // MARK: - Private Methods
    /// Provides configured cell for collection view.
    /// - Parameters:
    ///   - collectionView: Collection view object.
    ///   - indexPath: The index path that specifies the location of the cell in the collection view.
    ///   - item: The item that provides data for the cell.
    /// - Returns: Configured cell.
    private func cell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        with item: AnyHashable
    ) -> UICollectionViewCell? {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let section = dataSource
            .snapshot()
            .sectionIdentifiers[indexPath.section]
            .section
        
        let cell = section.cell(for: item, at: indexPath, in: collectionView)
        return cell
    }
    
    /// Provides configured reusable view for collection view.
    /// - Parameters:
    ///   - collectionView: Collection view object.
    ///   - kind: The kind of supplementary view to retrieve.
    ///   - indexPath: The index path specifying the location of the supplementary view in the collection view.
    /// - Returns: Configured reusable view object.
    private func supplementaryView(
        for collectionView: UICollectionView,
        with kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView? {
        
        let item = dataSource.itemIdentifier(for: indexPath)
        let section = dataSource
            .snapshot()
            .sectionIdentifiers[indexPath.section]
            .section
        
        return section.supplementaryView(
            kind: kind,
            for: item,
            at: indexPath,
            in: collectionView
        )
    }
    
    /// Provides configured layout for section in the collection view.
    /// - Parameters:
    ///   - sectionIndex: Index of the section specifying it's location in the collection view.
    ///   - environment: Layout’s container object.
    /// - Returns: Configured section layout object.
    private func layout(
        for sectionIndex: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection? {
        
        let section = dataSource
            .snapshot()
            .sectionIdentifiers[sectionIndex]
            .section
        return section.layout(environment: environment, collectionView: collectionView!)
    }
    
    /// Creates layout for collection view.
    /// - Returns: Configured layout for collection view.
    private func collectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = Size.Padding.large
        
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: layout
        )
        compositionalLayout.configuration = configuration
        compositionalLayout.register(
            BackgroundDecorationView.self,
            forDecorationViewOfKind: BackgroundDecorationView.reuseIdentifier
        )
        
        return compositionalLayout
    }
}

//MARK: - CollectionViewAdapter + UICollectionViewDelegate
extension CollectionViewAdapter: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let section = dataSource
            .snapshot()
            .sectionIdentifiers[indexPath.section]
            .section
        section.didSelect(at: indexPath)
        
        touchesDelegate?.cellSelected(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll(scrollView: scrollView)
    }
}
