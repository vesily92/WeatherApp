//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 29.03.2023.
//

import UIKit

final class CurrentWeatherView: BaseView {
    
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
    
    private let minTopConstant: CGFloat = 50
    private let maxTopConstant: CGFloat = 100
    private var animatedConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setAlpha()
    }
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.ViewModel.Current) {
        cityNameLabel.text = model.cityName
        temperatureLabel.text = model.temperature
        descriptionLabel.text = model.description
        temperatureRangeLabel.text = model.temperatureRange
        compactInfoLabel.text = model.compactInfo
    }
    
    func setLayout(with offset: CGFloat) {
        let currentConstraint = animatedConstraint!.constant
        var newConstraint = currentConstraint
            
        newConstraint = currentConstraint - (offset / 3)
        
        if newConstraint > maxTopConstant {
            animatedConstraint!.constant = maxTopConstant
        } else if newConstraint <= minTopConstant {
            animatedConstraint!.constant = minTopConstant
        } else {
            animatedConstraint!.constant = newConstraint
        }
    }
    
    func setAlpha() {
        temperatureRangeLabel.alpha = 1 - ((temperatureRangeLabel.frame.maxY - frame.maxY + 30) / 30)
        descriptionLabel.alpha = 1 - ((descriptionLabel.frame.maxY - frame.maxY + 25) / 30)
        temperatureLabel.alpha = 1 - ((temperatureLabel.frame.maxY - frame.maxY + 15) / 30)
        compactInfoLabel.alpha = -temperatureLabel.alpha
    }
    
    private func setupConstraints() {
        addSubview(cityNameLabel)
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)
        addSubview(temperatureRangeLabel)
        addSubview(compactInfoLabel)
        
        animatedConstraint = cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: maxTopConstant)
        
        NSLayoutConstraint.activate([
            cityNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            animatedConstraint!,
            
            compactInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            compactInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            compactInfoLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            
            temperatureRangeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureRangeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureRangeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        ])
    }
}
