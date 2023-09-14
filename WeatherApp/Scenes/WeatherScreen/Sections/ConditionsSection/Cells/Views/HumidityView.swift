//
//  HumidityView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class HumidityView: BaseView {
    private lazy var humidityLabel = UILabel(
        font: Font.regular.of(size: .header2),
        color: Color.main.white
    )
    
    private lazy var descriptionLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white
    )
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.Components.Humidity) {
        humidityLabel.text = model.humidity
        descriptionLabel.text = model.description
    }
    
    private func setupConstraints() {
        addSubview(humidityLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            humidityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            humidityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: humidityLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
}
