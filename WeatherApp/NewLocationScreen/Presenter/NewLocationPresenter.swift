//
//  NewLocationPresenter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 12.06.2023.
//

import Foundation

protocol INewLocationDelegate: AnyObject {
    func didAddNewLocation(with response: WeatherModel.Data)
}

protocol INewLocationPresenter {
    func setupView()
    func verifyLocations()
    
    func handleAddButtonTap()
}

final class NewLocationPresenter {
    weak var view: INewLocationViewController?
    
    weak var delegate: INewLocationDelegate?
    
    private let location: Location
    private let isNew: Bool
    private let manager: INewLocationScreenManager
    
    private var data: WeatherModel.Data
    
    init(location: Location,
         isNew: Bool,
         manager: INewLocationScreenManager,
         delegate: INewLocationDelegate) {
        self.location = location
        self.isNew = isNew
        self.manager = manager
        self.delegate = delegate
        
        self.data = WeatherModel.Data(location: location, weather: nil)
        
        self.manager.fetchWeatherFor(location) { [weak self] data in
            guard let self = self else { return }
            let viewModel = self.map(data)
            
            self.view?.render(with: viewModel)
            self.data = data
        }
    }
    
    private func map(
        _ data: WeatherModel.Data
    ) -> WeatherModel.ViewModel.WeatherScreen {
        let current = manager.setupCurrentWith(data: data)
        let sections = manager.createSectionsWith(data: data)
        
        return WeatherModel.ViewModel.WeatherScreen(
            current: current,
            sections: sections
        )
    }
}

extension NewLocationPresenter: INewLocationPresenter {
    func setupView() {
        let current = manager.setupCurrentWith(data: data)
        let viewModel = WeatherModel.ViewModel.WeatherScreen(
            current: current,
            sections: nil
        )
        view?.render(with: viewModel)
    }
    
    func verifyLocations() {
        view?.setupNavigationBar(forNewLocation: isNew)
    }
    
    func handleAddButtonTap() {
        delegate?.didAddNewLocation(with: data)
    }
}
