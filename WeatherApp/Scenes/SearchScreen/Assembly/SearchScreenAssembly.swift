//
//  SearchScreenAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import UIKit

final class SearchScreenAssembly {
    
    private let navigationController: UINavigationController
    private let coreDataManger: ICoreDataLocationManager
    private let mappingManager: IMappingManager
    private let viewModels: [WeatherModel.ViewModel]
    
    init(navigationController: UINavigationController,
         coreDataManger: ICoreDataLocationManager,
         mappingManager: IMappingManager,
         viewModels: [WeatherModel.ViewModel]) {
        self.navigationController = navigationController
        self.coreDataManger = coreDataManger
        self.mappingManager = mappingManager
        self.viewModels = viewModels
    }
}

extension SearchScreenAssembly: IAssembly {
    func assembly(viewController: UIViewController) {
        guard let viewController = viewController as? SearchScreenViewController else {
            return
        }
        
        let router = SearchScreenRouter(
            navigationController: navigationController
        )
        let searchScreenManager = DependencyContainer().makeSearchScreenManager(
            coreDataManager: coreDataManger,
            mappingManager: mappingManager
        )
        
        let presenter = SearchScreenPresenter(
            router: router,
            searchScreenManager: searchScreenManager,
            viewModels: viewModels
        )
        
        let resultsViewController = ResultsViewController()
        viewController.searchResultsController = resultsViewController
        
        presenter.resultsView = resultsViewController
        presenter.searchView = viewController
        
        viewController.presenter = presenter
        resultsViewController.presenter = presenter
    }
}
