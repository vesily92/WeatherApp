//
//  FooterCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 02.06.2023.
//

import UIKit

final class FooterCell: BaseCell {
    
    private lazy var titleLabel = UILabel(
        font: Font.semibold.of(size: .small),
        color: Color.main.white,
        textAlignment: .center
    )
    
    private lazy var subtitleLabel = UILabel(
        font: Font.regular.of(size: .caption),
        color: Color.translucent50.white,
        textAlignment: .center,
        text: "Provided by OpenWeather"
    )
    
    override func setupCell() {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = Color.translucent50.white
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(separator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.4),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.Padding.normal),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.Padding.normal),
            
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: Size.Padding.largeDouble),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -Size.Padding.largeDouble),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Size.Padding.largeDouble),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Size.Padding.largeDouble)
        ])
    }
    
    func configure(with model: WeatherModel.ViewModel.Current) {
        guard let name = model.fullName else { return }
        titleLabel.text = "Weather for \(name)"
    }
}
