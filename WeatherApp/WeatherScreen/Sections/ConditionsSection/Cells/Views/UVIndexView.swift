//
//  UVIndexView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class UVIndexView: BaseView {
    
    private lazy var indexLabel = UILabel(
        font: Font.regular.of(size: .header2),
        color: Color.main.white
    )
    
    private lazy var descriptionLabel = UILabel(
        font: Font.semibold.of(size: .medium),
        color: Color.main.white
    )
    private lazy var recommendationLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white
    )
    
    private lazy var lineIndicatorView: LineIndicatorView = {
        let view = LineIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.ViewModel.UVIndex) {
        indexLabel.text = model.index
        descriptionLabel.text = model.description
        recommendationLabel.text = model.recommendation
        
        lineIndicatorView.configure(
            with: .uvIndex(currentPoint: model.currentPoint)
        )
    }
    
    private func setupConstraints() {
        addSubview(indexLabel)
        addSubview(descriptionLabel)
        addSubview(lineIndicatorView)
        addSubview(recommendationLabel)

        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            indexLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.headerHeight),
//            indexLabel.topAnchor.constraint(equalTo: topAnchor, constant: Size.Padding.double),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            descriptionLabel.topAnchor.constraint(equalTo: indexLabel.bottomAnchor),

            lineIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            lineIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            lineIndicatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Size.Padding.normal),
            lineIndicatorView.heightAnchor.constraint(equalToConstant: Size.curveWidth),

            recommendationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            recommendationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            recommendationLabel.topAnchor.constraint(greaterThanOrEqualTo: lineIndicatorView.bottomAnchor, constant: Size.Padding.half),
            recommendationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.double)
        ])
    }
}
