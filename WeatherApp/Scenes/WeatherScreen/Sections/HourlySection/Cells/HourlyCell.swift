//
//  HourlyCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class HourlyCell: BaseCell {
    
    private lazy var hourlyView = HourlyView()
    private lazy var sunView = SunView()
    
    func configure(with model: WeatherModel.Components.Hourly) {
        switch model.cellType {
        case .hourly:
            sunView.removeFromSuperview()
            setup(hourlyView)
            hourlyView.configure(with: model)
        case .daily:
            hourlyView.removeFromSuperview()
            setup(sunView)
            sunView.configure(with: model)
        }
    }
    
    private func setup(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
