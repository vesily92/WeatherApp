//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 29.03.2023.
//

import UIKit

final class CurrentWeatherView: BaseView {
    
    // MARK: - Constants
    
    private let minTopConstant: CGFloat = 50
    private let maxTopConstant: CGFloat = 100
    
    // MARK: - Private Properties
    
    private lazy var cityNameLabel = UILabel(
        font: Font.semibold.of(size: .header1),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var temperatureLabel = UILabel(
        font: Font.light.of(size: .title),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var descriptionLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var temperatureRangeLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var compactInfoLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .center,
        alpha: 0
    )
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var animatedConstraint: NSLayoutConstraint?
    
    // MARK: - Overriden Methods
    
    override func setupView() {
        setupConstraints()
    }
    
    // MARK: - Internal Methods
    
    func configure(with model: WeatherModel.Components.Current) {
        cityNameLabel.text = model.cityName
        temperatureLabel.text = model.temperature
        descriptionLabel.text = model.description
        temperatureRangeLabel.text = model.temperatureRange
        compactInfoLabel.text = model.compactInfo
    }
    
    func updateLayout(with scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let bounceBorder = -scrollView.contentInset.top
        let scrollViewIsBouncing = offset < bounceBorder
        
        let headerSizeDelta = Size.currentWeatherViewMaxHeight - Size.currentWeatherViewMinHeight
        let constraintsDelta = maxTopConstant - minTopConstant
        let offsetScale = headerSizeDelta / constraintsDelta
        
        if scrollViewIsBouncing {
            var offset = min(scrollView.contentOffset.y, 0)
            if offset > -scrollView.safeAreaInsets.top {
                offset = -scrollView.safeAreaInsets.top
            }
            let newConstant = -offset / offsetScale
            
            animatedConstraint!.constant = newConstant + maxTopConstant
            
        } else {
            let newConstant = maxTopConstant - (offset / offsetScale)
            
            if newConstant > maxTopConstant {
                animatedConstraint!.constant = maxTopConstant
            } else if newConstant <= minTopConstant {
                animatedConstraint!.constant = minTopConstant
            } else {
                animatedConstraint!.constant = newConstant
            }
        }
        
        setAlphaForLabels(with: offset)
    }
    
    // MARK: - Private Methods
    
    private func setAlphaForLabels(with offset: CGFloat) {
        setAlphaFor(temperatureRangeLabel, by: offset)
        setAlphaFor(descriptionLabel, by: offset)
        setAlphaFor(temperatureLabel, by: offset)
        compactInfoLabel.alpha = -temperatureLabel.alpha
    }
    
    private func setAlphaFor(_ label: UIView, by offset: CGFloat) {
        let labelFrame = containerView.convert(label.frame.origin, to: self)
        let labelMaxY = labelFrame.y + label.frame.height
        
        let bottomInset = Size.currentWeatherViewMaxHeight - labelMaxY
        let distance = offset - bottomInset
        
        if distance >= 0 {
            label.alpha = 1 - (distance / (label.frame.height / 2))
        } else {
            label.alpha = 1
        }
    }
    
    private func setupConstraints() {
        addSubview(containerView)
        containerView.addSubview(cityNameLabel)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(temperatureRangeLabel)
        containerView.addSubview(compactInfoLabel)
        
        animatedConstraint = containerView.topAnchor.constraint(equalTo: topAnchor, constant: maxTopConstant)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, constant: -maxTopConstant),
            animatedConstraint!,
            
            cityNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            compactInfoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            compactInfoLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            
            temperatureRangeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            temperatureRangeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        ])
    }
}
