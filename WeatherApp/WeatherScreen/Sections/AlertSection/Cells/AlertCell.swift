//
//  AlertCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class AlertCell: BaseCell {
    
    private lazy var descriptionLabel = UILabel(
        font: Font.regular.of(size: .small),
        color: Color.main.white
    )
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
//        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 15, *) {
            let symbolFont = UIFont.systemFont(ofSize: 10, weight: .bold)
            let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)
            let image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
            var config = UIButton.Configuration.plain()
            config.title = "See More"
            config.image = image
            config.preferredSymbolConfigurationForImage = symbolConfig
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .systemFont(ofSize: 16, weight: .semibold)
                return outgoing
            }
            config.imagePadding = 20
            config.imagePlacement = .trailing
            config.baseForegroundColor = .white
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
            button.configuration = config
            button.contentHorizontalAlignment = .right
        } else {
            let symbolFont = UIFont.systemFont(ofSize: 12, weight: .bold)
            let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)
            let image = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
            button.setTitle("See More", for: .normal)
            button.setImage(image, for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.contentHorizontalAlignment = .left
            button.contentVerticalAlignment = .center
            button.transform = CGAffineTransform(scaleX: -1, y: 1)
            button.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
            button.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            button.titleEdgeInsets.left = 20
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        }
        return button
    }()
    
    override func setupCell() {
        setupConstraints()
    }
    
    func configure(with model: WeatherModel.ViewModel.Alert) {
        descriptionLabel.text = model.description
    }
    
    private func setupConstraints() {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = Color.translucent70.white
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(seeMoreButton)
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.Padding.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Size.Padding.double),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -Size.Padding.normal),
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Size.Padding.double),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.4),
            
            seeMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seeMoreButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
