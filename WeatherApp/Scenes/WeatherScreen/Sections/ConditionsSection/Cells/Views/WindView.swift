//
//  WindView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class WindView: BaseView {
    
    private lazy var speedLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var metricsLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white,
        textAlignment: .center,
        text: "m/s"
    )
    
    private lazy var view: WindIndicatorView = {
        let view = WindIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        let stackView = UIStackView(arrangedSubviews: [
            speedLabel,
            metricsLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = -4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(view)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Size.Padding.normal),
            
            view.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            view.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func configure(with model: WeatherModel.Components.Wind) {
        speedLabel.text = model.speed
        
        view.configure(with: model)
    }
}
