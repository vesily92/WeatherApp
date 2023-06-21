//
//  PressureView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class PressureView: BaseView {
    
    private lazy var pressureStateSymbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Color.main.white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var pressureLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var metricsLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white,
        textAlignment: .center,
        text: "mm Hg"
    )
    
    private lazy var minRangeLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white,
        textAlignment: .right,
        text: "Low"
    )
    
    private lazy var maxRangeLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white,
        textAlignment: .left,
        text: "High"
    )
    
    private lazy var pressureIndicatorView: PressureIndicatorView = {
        let view = PressureIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        let stackView = UIStackView(arrangedSubviews: [
            pressureStateSymbolView,
            pressureLabel,
            metricsLabel
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(pressureIndicatorView)
        addSubview(minRangeLabel)
        addSubview(maxRangeLabel)
        
        NSLayoutConstraint.activate([
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Size.Padding.normal),
            
            pressureIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
            pressureIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double),
            pressureIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pressureIndicatorView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            pressureIndicatorView.heightAnchor.constraint(equalTo: pressureIndicatorView.widthAnchor),
            
            minRangeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Size.Padding.double),
            minRangeLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -Size.Padding.double),
            minRangeLabel.topAnchor.constraint(greaterThanOrEqualTo: metricsLabel.bottomAnchor),
            minRangeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double),

            maxRangeLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: Size.Padding.double),
            maxRangeLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Size.Padding.double),
            maxRangeLabel.topAnchor.constraint(greaterThanOrEqualTo: metricsLabel.bottomAnchor),
            maxRangeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
    
    func configure(with model: WeatherModel.ViewModel.Pressure) {
        let symbolFont = Font.bold.of(size: .medium)
        let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)
        
        pressureLabel.text = model.pressure
        
        switch model.state {
        case .rising:
            pressureStateSymbolView.image = UIImage(
                systemName: "arrow.up"
            )?.withConfiguration(symbolConfig)
        case .falling:
            pressureStateSymbolView.image = UIImage(
                systemName: "arrow.down"
            )?.withConfiguration(symbolConfig)
        case .stable:
            pressureStateSymbolView.image = UIImage(
                systemName: "equal"
            )?.withConfiguration(symbolConfig)
        }
        
        pressureIndicatorView.configure(with: model)
    }
}
