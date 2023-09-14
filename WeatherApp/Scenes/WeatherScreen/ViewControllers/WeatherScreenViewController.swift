//
//  WeatherScreenViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 21.07.2023.
//

import UIKit

final class WeatherScreenViewController: UIViewController {
    
    private lazy var forecastView: ForecastView = {
        let view = ForecastView()
        return view
    }()
    
    init(viewModel: WeatherModel.ViewModel) {
        super.init(nibName: nil, bundle: nil)
        forecastView.configure(with: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = forecastView
    }
    
    func update(with viewModel: WeatherModel.ViewModel) {
        forecastView.configure(with: viewModel)
    }
}
