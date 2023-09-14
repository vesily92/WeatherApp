//
//  PrecipitationView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class PrecipitationView: BaseView {
    
    private lazy var precipitationLabel = UILabel(
        font: Font.regular.of(size: .header2),
        color: Color.main.white
    )
    
    private lazy var timeFrameLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white
    )
    
    private lazy var forecastLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white
    )
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.ViewModel.Precipitation) {
        precipitationLabel.text = model.pop
        timeFrameLabel.text = "in last 24h"
        forecastLabel.text = model.expectation
    }
    
    private func setupConstraints() {
        addSubview(precipitationLabel)
        addSubview(timeFrameLabel)
        addSubview(forecastLabel)

        NSLayoutConstraint.activate([
            precipitationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            precipitationLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),

            timeFrameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            timeFrameLabel.topAnchor.constraint(equalTo: precipitationLabel.bottomAnchor),

            forecastLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            forecastLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            forecastLabel.topAnchor.constraint(greaterThanOrEqualTo: timeFrameLabel.bottomAnchor),
            forecastLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
}
