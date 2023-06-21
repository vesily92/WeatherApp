//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import UIKit

protocol ISearchViewController: IListSectionConfiguratorDelegate, AnyObject {
    func render(with viewModel: WeatherModel.ViewModel.ListScreen)
    func send(data: [WeatherModel.Data])
}

final class SearchViewController: UIViewController {
    
    var onWeatherDataChange: (([WeatherModel.Data]) -> Void)?
    
    var presenter: ISearchViewPresenter!
    var searchResultsController: ResultsViewController!
    
    private var searchController: UISearchController!
    private var collectionView: UICollectionView!
    
    private var selectedCell: ListCell?
    
    private var sections: [Section]? {
        didSet { adapter.makeSnapshot(animated: true) }
    }
    
    private lazy var adapter = CollectionViewAdapter(
        delegate: self,
        collectionView: collectionView,
        touchesDelegate: self
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.main.black
        
        setupNavBar()
        setupCollectionView()
        setupSearchController()
        
        presenter.renderSearchView()
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
        title = "Weather"
    }
    
    private func setupSearchController() {
        searchController = UISearchController(
            searchResultsController: searchResultsController
        )
        
        searchController.searchBar.placeholder = "Search for city"
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: layout
        )
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(collectionView)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        let query = text.replacingOccurrences(of: " ", with: "_")
        
        presenter.search(with: query)
    }
}

extension SearchViewController: ISearchViewController {
    func render(with viewModel: WeatherModel.ViewModel.ListScreen) {
        sections = viewModel.sections
    }

    func send(data: [WeatherModel.Data]) {
        onWeatherDataChange?(data)
    }
}

extension SearchViewController: ICollectionViewAdapterDelegate {
    func sectionsForCollectionView() -> [Section] {
        guard let sections = sections else { return [] }
        return sections
    }
}

extension SearchViewController: ITouchesDelegate {
    func cellSelected(at indexPath: IndexPath) {
        presenter.handleCellSelection(at: indexPath.item)
    }
}

extension SearchViewController: IListSectionConfiguratorDelegate  {
    func didRemoveCell(for item: AnyHashable, at index: Int) {
        adapter.makeSnapshot(animated: true)
        presenter.handleCellRemoval(at: index)
    }
}

extension SearchViewController: IUpdatableWithData {
    func updateWith(_ data: [WeatherModel.Data]) {
        presenter.updateWith(data)
    }
}
