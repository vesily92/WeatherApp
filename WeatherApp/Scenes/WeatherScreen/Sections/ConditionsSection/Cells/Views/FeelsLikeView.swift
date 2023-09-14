//
//  FeelsLikeView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class FeelsLikeView: BaseView {
    
    private lazy var feelsLikeLabel = UILabel(
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
    
    func configure(with model: WeatherModel.Components.FeelsLike) {
        feelsLikeLabel.text = model.temperature
        descriptionLabel.text = model.description
    }
    
    private func setupConstraints() {
        addSubview(feelsLikeLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            feelsLikeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            feelsLikeLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: feelsLikeLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
}
