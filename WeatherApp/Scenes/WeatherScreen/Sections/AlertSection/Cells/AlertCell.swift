//
//  AlertCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class AlertCell: BaseCell {
    
    private lazy var alertView: AlertView = {
        let view = AlertView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.Components.Alert) {
        alertView.configure(with: model)
    }
    
    private func setupConstraints() {
        contentView.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            alertView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            alertView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            alertView.topAnchor.constraint(equalTo: contentView.topAnchor),
            alertView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
