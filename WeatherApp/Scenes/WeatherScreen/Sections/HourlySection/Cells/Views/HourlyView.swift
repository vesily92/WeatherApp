//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class HourlyView: BaseView {
    
    private lazy var timeLabel = UILabel(
        font: Font.semibold.of(size: .small),
        color: Color.main.white
    )
    
    private lazy var popLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.teal
    )
    
    private lazy var temperatureLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white
    )
    
    private lazy var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.Components.Hourly) {
        timeLabel.text = model.time
        temperatureLabel.text = model.temperature
        popLabel.text = model.pop
        symbolView.image = UIImage(
            systemName: model.symbolName
        )?.withRenderingMode(.alwaysOriginal)
    }
    
    private func setupConstraints() {
        let iconPopStackView = UIStackView(arrangedSubviews: [
            symbolView,
            popLabel
        ])
        iconPopStackView.axis = .vertical
        iconPopStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            iconPopStackView,
            temperatureLabel
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
