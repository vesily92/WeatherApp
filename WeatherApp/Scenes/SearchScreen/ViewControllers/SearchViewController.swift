//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import UIKit

protocol ISearchScreenViewController: AnyObject {
    
    func render(with viewModels: [WeatherModel.ViewModel])
    func deactivateSearchController()
    func send(viewModels: [WeatherModel.ViewModel])
}

final class SearchScreenViewController: UIViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, WeatherModel.ViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, WeatherModel.ViewModel>
    
    var onViewModelsDidChange: (([WeatherModel.ViewModel]) -> Void)?
    
    var coordinator: ICoordinator?
    var presenter: ISearchScreenPresenter!
    var searchResultsController: ResultsViewController!
    
    private var searchController: UISearchController!
    private var collectionView: UICollectionView!
    
    private var dataSource: DataSource?
    
    private var viewModels: [WeatherModel.ViewModel] = []
    
    private var selectedIndexPath: IndexPath?
    private var cellsFrames: [CGRect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.main.black
        
        setupNavBar()
        setupCollectionView()
        setupSearchController()
        createDataSource()
        
        presenter.render()
        
        makeSnapshot(animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = editButtonItem
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        title = "Weather"
    }
    
    private func setupSearchController() {
        searchController = UISearchController(
            searchResultsController: searchResultsController
        )
        searchController.searchBar.placeholder = "Search for city"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
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
        
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: layout
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        
        view.addSubview(collectionView)
    }
    
    private func createDataSource() {
        let searchCellRegistration = UICollectionView.CellRegistration<SearchScreenCell, WeatherModel.ViewModel> { [weak self] cell, indexPath, item in
            guard let self = self else { return }
            
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
            cell.configure(with: item.list)
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: searchCellRegistration,
                for: indexPath,
                item: item
            )
        }
        dataSource?.reorderingHandlers.canReorderItem = { item in return true }
        
        dataSource?.reorderingHandlers.didReorder = { [weak self] transaction in
            transaction.sectionTransactions.forEach { sectionTransaction in
                guard let self = self else { return }
                
                var viewModels = self.viewModels
                viewModels = sectionTransaction.finalSnapshot.items
                self.viewModels = viewModels
                
                DispatchQueue.main.async {
                    self.presenter.handleCellReorder(viewModels)
                }
            }
        }
    }
    
    private func deleteItem(_ item: WeatherModel.ViewModel) {
        if let index = viewModels
            .firstIndex(where: { $0.list.id == item.list.id }) {
            presenter.handleCellRemoval(at: index)
            makeSnapshot(animated: true)
        }
    }
    
    private func trailingSwipeActionsConfiguration(
        for indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        if indexPath.item != 0 {
            guard indexPath.item < viewModels.count else { return nil }
            
            let item = viewModels[indexPath.item]
            
            let configuration = UISwipeActionsConfiguration(
                actions: [deleteAction(item)]
            )
            
            return configuration
        }
        return nil
    }
    
    private func deleteAction(
        _ item: WeatherModel.ViewModel
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
    
    
    private func makeSnapshot(animated: Bool) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.zero])
        snapshot.appendItems(viewModels, toSection: .zero)
        
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
    
    
    
    func getFramesForCells() {
        collectionView.layoutIfNeeded()
        var frames: [CGRect] = []
        
        for item in 0..<viewModels.count {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            guard let cell = collectionView.cellForItem(
                at: indexPath
            ) as? SearchScreenCell else {
                return
            }
            let cardViewFrame = cell.convert(cell.cardView.frame, to: nil)
            frames.append(cardViewFrame)
            
        }
        cellsFrames = frames
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let query = text.replacingOccurrences(of: " ", with: "_")
        
        presenter.search(with: query)
    }
}

extension SearchScreenViewController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        getFramesForCells()
        selectedIndexPath = indexPath
        presenter.handleCellSelection(at: indexPath.item)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        targetIndexPathForMoveOfItemFromOriginalIndexPath originalIndexPath: IndexPath,
        atCurrentIndexPath currentIndexPath: IndexPath,
        toProposedIndexPath proposedIndexPath: IndexPath
    ) -> IndexPath {
        
        var destination = proposedIndexPath
        
        if proposedIndexPath.item == 0 {
            destination = IndexPath(
                item: proposedIndexPath.item + 1,
                section: proposedIndexPath.section
            )
        }
        
        return destination
    }
}

extension SearchScreenViewController: ISearchScreenViewController {
    
    func render(with viewModels: [WeatherModel.ViewModel]) {
        self.viewModels = viewModels
        DispatchQueue.main.async { [self] in
            makeSnapshot(animated: true)
        }
    }
    
    func deactivateSearchController() {
        searchController.isActive = false
    }
    
    func send(viewModels: [WeatherModel.ViewModel]) {
        onViewModelsDidChange?(viewModels)
    }
}

extension SearchScreenViewController: IZoomingTransitionViewController {
    
    func animatedView(by index: Int?, onMain: Bool?) -> UIView? {
        if let index = index {
            selectedIndexPath = IndexPath(item: index, section: 0)
        }
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        
        let viewModel = presenter.getViewModel(by: selectedIndexPath.item)
        let cardView = LocationCardView()
        cardView.configure(with: viewModel)
        
        if cellsFrames.isEmpty {
            return nil
        }
        
        let visibleCells = collectionView.visibleCells.count
        
        if selectedIndexPath.item <= visibleCells {
            cardView.frame = cellsFrames[selectedIndexPath.item]
            return cardView
        }
        return nil
    }
}
