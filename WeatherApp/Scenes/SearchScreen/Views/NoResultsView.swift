//
//  NoResultsView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 07.06.2023.
//

import UIKit

final class NoResultsView: BaseView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 46)
        )
        let image = UIImage(
            systemName: "magnifyingglass",
            withConfiguration: config
        )
        imageView.image = image
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var titleLabel = UILabel(
        font: Font.bold.of(size: .medium),
        color: Color.main.white,
        text: "No Results"
    )
    
    private lazy var subtitleLabel = UILabel(
        font: Font.bold.of(size: .small),
        color: Color.translucent50.white
    )
    
    override func setupView() {
        setupConstraints()
    }
    
    func configure(with query: String) {
        let text = query.replacingOccurrences(of: "_", with: " ")
        subtitleLabel.text = "No results found for \"\(text)\"."
    }
    
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            titleLabel,
            subtitleLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
