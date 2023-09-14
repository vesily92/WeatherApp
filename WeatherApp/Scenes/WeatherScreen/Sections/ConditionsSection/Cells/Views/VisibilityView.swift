//
//  VisibilityView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class VisibilityView: BaseView {
    private lazy var visibilityLabel = UILabel(
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
    
    func configure(with model: WeatherModel.ViewModel.Visibility) {
        visibilityLabel.text = model.distance
        descriptionLabel.text = model.description
    }
    
    private func setupConstraints() {
        addSubview(visibilityLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            visibilityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            visibilityLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: visibilityLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
}
