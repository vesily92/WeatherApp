//
//  Router.swift
//  WeatherApp
//
//  Created by Василий Пронин on 07.06.2023.
//

import UIKit

protocol IWeatherScreenRouter {
    
    func route(to target: WeatherScreenTarget)
}

enum WeatherScreenTarget {
    case searchScreen(pageIndex: Int)
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
        case .searchScreen(let pageIndex):
            // FIX ME
            let animated = pageIndex <= 5
            
            let transitionManager = TransitionManager(pageIndex: pageIndex)
            navigationController.delegate = transitionManager
            
            navigationController.setNavigationBarHidden(false, animated: false)
            navigationController.setToolbarHidden(true, animated: animated)
            navigationController.popViewController(animated: animated)
        }
    }
}
