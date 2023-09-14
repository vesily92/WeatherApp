//
//  SunView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class SunView: BaseView {
    
    private lazy var timeLabel = UILabel(
        font: Font.semibold.of(size: .small),
        color: Color.main.white
    )
    
    private lazy var eventLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white
    )
    
    private lazy var symbolView = UIImageView()
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.Components.Hourly) {
        timeLabel.text = model.time
        eventLabel.text = model.event
        symbolView.image = UIImage(
            systemName: model.symbolName
        )?.withRenderingMode(.alwaysOriginal)
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            symbolView,
            eventLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
