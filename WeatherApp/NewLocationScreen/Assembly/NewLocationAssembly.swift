//
//  NewLocationAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 15.06.2023.
//

import UIKit

final class NewLocationAssembly {
    private let navigationController: UINavigationController
    private let location: Location
    private let isNew: Bool
//    private let locations: [Location]
    private let delegate: INewLocationDelegate
    
    //    private let delegate: IWeatherPresenterDelegate
    
    init(navigationController: UINavigationController,
         location: Location,
         isNew: Bool,
//         locations: [Location],
         delegate: INewLocationDelegate
         //         delegate: IWeatherPresenterDelegate
    ) {
        
        self.navigationController = navigationController
        self.location = location
        self.isNew = isNew
//        self.locations = locations
        self.delegate = delegate
        
        //        self.delegate = delegate
    }
}

extension NewLocationAssembly: IAssembly {
    func assembly(viewController: UIViewController) {
        
        guard let viewController = viewController as? NewLocationViewController else {
            return
        }
        let manager = DependencyContainer().makeNewLocationScreenManager()
        
        let presenter = NewLocationPresenter(
            location: location,
            isNew: isNew,
            manager: manager,
            delegate: delegate
        )
        
        presenter.view = viewController
        viewController.presenter = presenter
    }
}
