//
//  WeatherScreenPresenter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

protocol IWeatherScreenPresenter {
    
    func numberOfPages() -> Int
    func render()
    func updateWith(viewModels: [WeatherModel.ViewModel])
    func getViewModel(by index: Int?) -> WeatherModel.ViewModel
    func didTapSearchButton(on page: Int)
}

final class WeatherScreenPresenter {
    
    weak var view: IWeatherScreenPageViewController?
    
    private let router: IWeatherScreenRouter
    private let index: Int
    
    private var viewModels: [WeatherModel.ViewModel] = []
    
    init(router: IWeatherScreenRouter,
         viewModels: [WeatherModel.ViewModel],
         index: Int) {
        self.router = router
        self.viewModels = viewModels
        self.index = index
    }
}

extension WeatherScreenPresenter: IWeatherScreenPresenter {
    
    func numberOfPages() -> Int {
        viewModels.count
    }
    
    func render() {
        view?.setupPageViewController(with: viewModels, pageIndex: index)
    }
    
    func updateWith(viewModels: [WeatherModel.ViewModel]) {
        DispatchQueue.main.async {
            self.viewModels = viewModels
            self.view?.updateViewControllers(with: viewModels)
        }
        
    }
    
    func getViewModel(by index: Int?) -> WeatherModel.ViewModel {
        if let index = index {
            return viewModels[index]
        } else {
            return viewModels[self.index]
        }
    }
    
    func didTapSearchButton(on page: Int) {
        router.route(
            to: .searchScreen(
                pageIndex: page
            )
        )
    }
}
