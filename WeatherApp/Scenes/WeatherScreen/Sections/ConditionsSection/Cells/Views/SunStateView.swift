//
//  SunStateView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class SunStateView: BaseView {
    
    private lazy var timeLabel = UILabel(
        font: Font.regular.of(size: .header2),
        color: Color.main.white
    )
    
    private lazy var nextEventLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white
    )
    
    private lazy var sunIndicatorView: SunIndicatorView = {
        let view = SunIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.ViewModel.SunState) {
        timeLabel.text = model.time
        nextEventLabel.text = model.nextEvent
        sunIndicatorView.configure(with: model.progress)
    }
    
    private func setupConstraints() {
        addSubview(timeLabel)
        addSubview(nextEventLabel)
        addSubview(sunIndicatorView)
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
            
            sunIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sunIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sunIndicatorView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            sunIndicatorView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            nextEventLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            nextEventLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            nextEventLabel.topAnchor.constraint(greaterThanOrEqualTo: sunIndicatorView.bottomAnchor, constant: Size.Padding.half),
            nextEventLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
}
