//
//  SearchScreenRouter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 08.06.2023.
//

import UIKit

protocol ISearchScreenRouter {
    func route(to target: SearchScreenTarget)
}

enum SearchScreenTarget {
    case weatherScreen(
        viewModels: [WeatherModel.ViewModel],
        index: Int
    )
    case newLocationScreen(
        viewModel: WeatherModel.ViewModel,
        isNew: Bool,
        delegate: INewLocationDelegate
    )
}

final class SearchScreenRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension SearchScreenRouter: ISearchScreenRouter {
    func route(to target: SearchScreenTarget) {
        switch target {
        case .weatherScreen(let viewModels, let index):
            let weatherScreenViewController = WeatherScreenPageViewController()
            let transitionManager = TransitionManager()
            
            WeatherScreenAssembly(
                navigationController: navigationController,
                viewModels: viewModels,
                index: index
            ).assembly(viewController: weatherScreenViewController)
            
            navigationController.delegate = transitionManager
            navigationController.pushViewController(
                weatherScreenViewController,
                animated: true
            )
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.setToolbarHidden(false, animated: true)
            
        case .newLocationScreen(let viewModel, let isNew, let delegate):
            let newLocationViewController = NewLocationViewController()
            
            NewLocationAssembly(
                navigationController: navigationController,
                viewModel: viewModel,
                isNew: isNew,
                delegate: delegate
            ).assembly(viewController: newLocationViewController)
            
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.setToolbarHidden(true, animated: true)
            
            let nestedNavigationController = UINavigationController(
                rootViewController: newLocationViewController
            )
            navigationController.present(nestedNavigationController, animated: true)
        }
    }
}
