//
//  WeatherScreenAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class WeatherScreenAssembly {
    private let navigationController: UINavigationController
    private let data: [WeatherModel.Data]
        
    init(navigationController: UINavigationController,
         data: [WeatherModel.Data]) {
        self.navigationController = navigationController
        self.data = data
    }
}

extension WeatherScreenAssembly: IAssembly {
    func assembly(viewController: UIViewController) {
        guard let viewController = viewController as? WeatherViewController else {
            return
        }
        let router = WeatherScreenRouter(
            navigationController: navigationController
        )
        let manager = DependencyContainer().makeWeatherScreenManager()
        
        let presenter = WeatherPresenter(
            router: router,
            manager: manager,
            data: data
        )
        presenter.view = viewController
        viewController.presenter = presenter
    }
}
