//
//  ConditionView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 20.04.2023.
//

import UIKit

final class ConditionView: BaseView {
    
    // MARK: - Private Properties
    
    private lazy var uvIndexView = UVIndexView()
    private lazy var sunStateView = SunStateView()
    private lazy var windView = WindView()
    private lazy var precipitationView = PrecipitationView()
    private lazy var feelsLikeView = FeelsLikeView()
    private lazy var humidityView = HumidityView()
    private lazy var visibilityView = VisibilityView()
    private lazy var pressureView = PressureView()
    
    // MARK: - Internal Methods
    
    func configure(with model: WeatherModel.Components.Conditions) {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        switch model.type {
        case .uvIndex:
            guard let uvIndex = model.uvIndex else { return }
            setupConstraints(uvIndexView)
            uvIndexView.configure(with: uvIndex)
            
        case .sunrise:
            guard let sunState = model.sunState else { return }
            setupConstraints(sunStateView)
            sunStateView.configure(with: sunState)
            
        case .sunset:
            guard let sunState = model.sunState else { return }
            setupConstraints(sunStateView)
            sunStateView.configure(with: sunState)
            
        case .wind:
            guard let wind = model.wind else { return }
            setupConstraints(windView)
            windView.configure(with: wind)
            
        case .precipitation:
            guard let precipitation = model.precipitation else { return }
            setupConstraints(precipitationView)
            precipitationView.configure(with: precipitation)
            
        case .rainfall:
            guard let precipitation = model.precipitation else { return }
            setupConstraints(precipitationView)
            precipitationView.configure(with: precipitation)
            
        case .feelsLike:
            guard let feelsLike = model.feelsLike else { return }
            setupConstraints(feelsLikeView)
            feelsLikeView.configure(with: feelsLike)
            
        case .humidity:
            guard let humidity = model.humidity else { return }
            setupConstraints(humidityView)
            humidityView.configure(with: humidity)
            
        case .visibility:
            guard let visibility = model.visibility else { return }
            setupConstraints(visibilityView)
            visibilityView.configure(with: visibility)
            
        case .pressure:
            guard let pressure = model.pressure else { return }
            setupConstraints(pressureView)
            pressureView.configure(with: pressure)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - ConditionView + Extension

extension ConditionView {
    
    func makeMask(for margin: CGFloat) {
        layer.mask = setAlphaMask(with: margin / frame.size.height)
        layer.masksToBounds = true
    }
    
    private func setAlphaMask(with location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor.white.withAlphaComponent(0),
                       UIColor.white].map { $0.cgColor }
        
        let num = location as NSNumber
        mask.locations = [num, num]
        return mask
    }
}
