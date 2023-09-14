//
//  LocationCardView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 04.04.2023.
//

import UIKit

final class LocationCardView: BaseView {
    
    override class var layerClass: AnyClass { return BackgroundGradientLayer.self }
    
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
    
    private lazy var descriptionLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.white,
        textAlignment: .left
    )
    
    private lazy var temperatureLabel = UILabel(
        font: Font.regular.of(size: .large),
        color: Color.main.white,
        textAlignment: .right
    )
    
    private lazy var temperatureRangeLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.white,
        textAlignment: .right
    )
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var gradientColor: BackgroundType = .dayClear {
        didSet {
            setupGradient()
        }
    }
    
    override func setupView() {
        setupGradient()
        setupConstraints()
    }
    
    private func setupGradient() {
        let backgroundGradient = layer as! BackgroundGradientLayer
        backgroundGradient.configure(with: gradientColor)
        backgroundGradient.cornerRadius = Size.cornerRadius
    }
    
    private func setupConstraints() {
        
        containerView.addSubview(locationLabel)
        containerView.addSubview(captionLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(temperatureLabel)
        containerView.addSubview(temperatureRangeLabel)

        addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            locationLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Size.Padding.double
            ),
            locationLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Size.Padding.normal
            ),

            captionLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Size.Padding.double
            ),
            captionLabel.topAnchor.constraint(
                equalTo: locationLabel.bottomAnchor
            ),

            descriptionLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Size.Padding.double
            ),
            descriptionLabel.topAnchor.constraint(
                greaterThanOrEqualTo: captionLabel.bottomAnchor,
                constant: Size.Padding.double
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Size.Padding.double
            ),

            temperatureLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Size.Padding.half
            ),
            temperatureLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Size.Padding.double
            ),

            temperatureRangeLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Size.Padding.double
            ),
            temperatureRangeLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Size.Padding.double
            )
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
    
    func configure(with model: WeatherModel.Components.Current) {
        locationLabel.text = model.cityName
        captionLabel.text = model.time
        descriptionLabel.text = model.description
        temperatureLabel.text = model.temperature
        temperatureRangeLabel.text = model.temperatureRange
        gradientColor = model.backgroundColor
    }
}

