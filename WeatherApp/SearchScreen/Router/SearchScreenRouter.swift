//
//  SearchScreenRouter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 08.06.2023.
//

import UIKit

enum SearchScreenTarget {
    case weatherScreen
    case newLocationScreen(
        location: Location,
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
        case .weatherScreen:
            navigationController.popViewController(animated: true)
            navigationController.setToolbarHidden(false, animated: true)

        case let .newLocationScreen(location, isNew, delegate):
            let newLocationViewController = NewLocationViewController()
            NewLocationAssembly(
                navigationController: navigationController,
                location: location,
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
