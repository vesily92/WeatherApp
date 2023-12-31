//
//  BackgroundDecorationView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class BackgroundDecorationView: UICollectionReusableView {
    
    // MARK: - Private Properties
    
    private lazy var blurView: BlurView = {
        let view = BlurView()
        view.layer.cornerRadius = Size.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
