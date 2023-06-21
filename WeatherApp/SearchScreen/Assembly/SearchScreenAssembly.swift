//
//  SearchScreenAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import UIKit

final class SearchScreenAssembly {
    
    private let navigationController: UINavigationController
    private let data: [WeatherModel.Data]
    private let delegate: ISearchScreenDelegate
    
    init(navigationController: UINavigationController,
         data: [WeatherModel.Data],
         delegate: ISearchScreenDelegate) {
        self.navigationController = navigationController
        self.data = data
        self.delegate = delegate
    }
}

extension SearchScreenAssembly: IAssembly {
    func assembly(viewController: UIViewController) {
        guard let viewController = viewController as? SearchViewController else {
            return
        }
        
        let router = SearchScreenRouter(
            navigationController: navigationController
        )
        let manager = DependencyContainer().makeSearchScreenManager()
        
        let presenter = SearchScreenPresenter(
            router: router,
            manager: manager,
            data: data,
            delegate: delegate
        )
        
        let resultsViewController = ResultsViewController()
        viewController.searchResultsController = resultsViewController
        
        presenter.resultsView = resultsViewController
        presenter.searchView = viewController
        
        viewController.presenter = presenter
        resultsViewController.presenter = presenter
    }
}
