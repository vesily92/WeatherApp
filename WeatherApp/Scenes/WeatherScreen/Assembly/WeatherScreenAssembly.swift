//
//  WeatherScreenAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class WeatherScreenAssembly {
    
    private let navigationController: UINavigationController
    private let viewModels: [WeatherModel.ViewModel]
    private let index: Int
    
    init(navigationController: UINavigationController,
         viewModels: [WeatherModel.ViewModel],
         index: Int = 0
    ) {
        self.navigationController = navigationController
        self.viewModels = viewModels
        self.index = index
    }
}

extension WeatherScreenAssembly: IAssembly {
    
    func assembly(viewController: UIViewController) {
        guard let viewController = viewController as? WeatherScreenPageViewController else {
            return
        }
        
        let router = WeatherScreenRouter(
            navigationController: navigationController
        )
        
        let presenter = WeatherScreenPresenter(
            router: router,
            viewModels: viewModels,
            index: index
        )
        
        presenter.view = viewController
        viewController.presenter = presenter
    }
}
