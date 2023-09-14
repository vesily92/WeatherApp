//
//  SectionHeader.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    
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
    
    var contentView: UIView!
    var animatedConstraint: NSLayoutConstraint!
    
    var offset: CGFloat = 0 {
        didSet {
            animatedConstraint.constant = offset
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = UIView(frame: frame)
        
        contentView.addSubview(symbolView)
        contentView.addSubview(titleLabel)
        
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            symbolView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            symbolView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            symbolView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: 4),
            titleLabel.centerYAnchor.constraint(equalTo: symbolView.centerYAnchor)
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        animatedConstraint = contentView.topAnchor.constraint(equalTo: self.topAnchor)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: self.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            animatedConstraint
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with type: SectionType.WeatherScreen) {
        let symbolFont = Font.semibold.of(size: .header3)
        let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)
        
        titleLabel.text = type.title
        symbolView.image = UIImage(
            systemName: type.symbolName
        )?.withConfiguration(symbolConfig)
    }
    
    func setAlphaForHeader(with offset: CGFloat) {
        contentView.alpha = offset
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

