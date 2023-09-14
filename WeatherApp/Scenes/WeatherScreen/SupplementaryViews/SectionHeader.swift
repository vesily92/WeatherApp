//
//  SectionHeader.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    
    // MARK: - Internal Properties
    
    var containerView: UIView!
    var animatedConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private lazy var titleLabel = UILabel(
        font: Font.semibold.of(size: .header3),
        color: Color.translucent50.white
    )
    
    private lazy var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.alpha = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Overriden Methods
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIView(frame: frame)
        containerView.addSubview(symbolView)
        containerView.addSubview(titleLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            symbolView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            //            symbolView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            symbolView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            symbolView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: 4),
            titleLabel.centerYAnchor.constraint(equalTo: symbolView.centerYAnchor)
        ])
        
        animatedConstraint = containerView.topAnchor.constraint(equalTo: topAnchor)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animatedConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configure(with type: SectionType.WeatherScreen) {
        let symbolFont = Font.semibold.of(size: .header3)
        let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)
        
        titleLabel.text = type.title
        symbolView.image = UIImage(
            systemName: type.symbolName
        )?.withConfiguration(symbolConfig)
    }
    
    func setAlphaForHeader(with offset: CGFloat) {
        containerView.alpha = offset
    }
    
    func setConstraint(with offset: CGFloat) {
        animatedConstraint.constant = offset
    }
}
