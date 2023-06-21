//
//  Router.swift
//  WeatherApp
//
//  Created by Василий Пронин on 07.06.2023.
//

import UIKit

enum WeatherScreenTarget {
    case searchScreen(
        data: [WeatherModel.Data],
        delegate: ISearchScreenDelegate
    )
}

final class WeatherScreenRouter {
    private let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension WeatherScreenRouter: IWeatherScreenRouter {
    func route(to target: WeatherScreenTarget) {
        switch target {
        case let .searchScreen(data, delegate):
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.setToolbarHidden(true, animated: true)
            
            let searchViewController = SearchViewController()
            
            SearchScreenAssembly(
                navigationController: navigationController,
                data: data,
                delegate: delegate
            ).assembly(viewController: searchViewController)
            
            navigationController.pushViewController(
                searchViewController,
                animated: true
            )
        }
    }
}
