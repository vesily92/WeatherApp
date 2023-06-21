//
//  ListCardView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 04.04.2023.
//

import UIKit

final class ListCardView: BaseView {
    
    private lazy var locationLabel = UILabel(
        font: Font.bold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .left
    )
    
    private lazy var captionLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.white,
        textAlignment: .left
    )
    
    private lazy var temperatureLabel = UILabel(
        font: Font.regular.of(size: .large),
        color: Color.main.white,
        textAlignment: .right
    )
    
    private lazy var descriptionLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.white,
        textAlignment: .left
    )
    
    private lazy var temperatureRangeLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.white,
        textAlignment: .right
    )
    
    override func setupView() {
        self.layer.cornerRadius = Size.cornerRadius
        self.backgroundColor = .systemGray2
        
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        addSubview(locationLabel)
        addSubview(captionLabel)
        addSubview(descriptionLabel)
        addSubview(temperatureLabel)
        addSubview(temperatureRangeLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.Padding.normal),
            
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            captionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: captionLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double),
            
            temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: locationLabel.trailingAnchor, constant: Size.Padding.double),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            temperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.Padding.half),
            
            temperatureRangeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            temperatureRangeLabel.topAnchor.constraint(greaterThanOrEqualTo: temperatureLabel.bottomAnchor),
            temperatureRangeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
    
    
    func viewsToAnimate() -> [UIView] {
        [
            locationLabel,
            captionLabel,
            descriptionLabel,
            temperatureLabel,
            temperatureRangeLabel
        ]
    }
    
    func configure(with model: WeatherModel.ViewModel.Current) {
        locationLabel.text = model.cityName
        captionLabel.text = model.time
        descriptionLabel.text = model.description
        temperatureLabel.text = model.temperature
        temperatureRangeLabel.text = model.temperatureRange
    }
}

