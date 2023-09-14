//
//  NewLocationAssembly.swift
//  WeatherApp
//
//  Created by Василий Пронин on 15.06.2023.
//

import UIKit

final class NewLocationAssembly {
    
    private let navigationController: UINavigationController
    private let viewModel: WeatherModel.ViewModel
    private let isNew: Bool
    private let delegate: INewLocationDelegate
    
    init(navigationController: UINavigationController,
         viewModel: WeatherModel.ViewModel,
         isNew: Bool,
         delegate: INewLocationDelegate
    ) {
        
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.isNew = isNew
        self.delegate = delegate
    }
}

extension NewLocationAssembly: IAssembly {
    
    func assembly(viewController: UIViewController) {
        
        guard let viewController = viewController as? NewLocationViewController else {
            return
        }
        
        let presenter = NewLocationPresenter(
            viewModel: viewModel,
            isNew: isNew,
            delegate: delegate
        )
        
        presenter.view = viewController
        viewController.presenter = presenter
    }
}
