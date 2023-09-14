//
//  DailyCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class DailyCell: BaseCell {
    
    private lazy var weekdayLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white
    )
    
    private lazy var maxTemperatureLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .right
    )
    private lazy var minTemperatureLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white,
        textAlignment: .right,
        alpha: 0.5
    )
    private lazy var popLabel = UILabel(
        font: Font.semibold.of(size: .caption),
        color: Color.main.teal,
        autoresizingMask: true
    )
    
    private lazy var lineIndicatorView: LineIndicatorView = {
        let view = LineIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var symbolView = UIImageView()
    
    override func setupCell() {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = Color.translucent50.white
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        
        let symbolStack = UIStackView(arrangedSubviews: [
            symbolView,
            popLabel
        ])
        symbolStack.axis = .vertical
        symbolStack.alignment = .center
        symbolStack.distribution = .equalCentering
        
        let leadingStack = UIStackView(arrangedSubviews: [
            weekdayLabel,
            symbolStack
        ])
        leadingStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leadingStack)
        
        contentView.addSubview(minTemperatureLabel)
        contentView.addSubview(maxTemperatureLabel)
        contentView.addSubview(lineIndicatorView)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.Padding.double),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.Padding.double),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.4),
            
            leadingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.Padding.double),
            leadingStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leadingStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.32),
            
            minTemperatureLabel.trailingAnchor.constraint(equalTo: lineIndicatorView.leadingAnchor, constant: -Size.Padding.normal),
            minTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minTemperatureLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.12),
            
            lineIndicatorView.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor, constant: -Size.Padding.normal),
            lineIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lineIndicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.29),
            lineIndicatorView.heightAnchor.constraint(equalToConstant: Size.curveWidth),
            
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.Padding.double),
            maxTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            maxTemperatureLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.12)
        ])
    }
    
    func configure(with model: WeatherModel.Components.Daily) {
        weekdayLabel.text = model.time
        maxTemperatureLabel.text = model.maxTemperature
        minTemperatureLabel.text = model.minTemperature
        popLabel.text = model.pop
        symbolView.image = UIImage(
            systemName: model.symbolName
        )?.withRenderingMode(.alwaysOriginal)
        
        lineIndicatorView.configure(
            with: .temperature(model.indicatorViewModel)
        )
    }
}
