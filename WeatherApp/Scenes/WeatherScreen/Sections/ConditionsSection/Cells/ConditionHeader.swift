//
//  ConditionHeader.swift
//  WeatherApp
//
//  Created by Василий Пронин on 20.04.2023.
//

import UIKit

final class ConditionHeader: UIView {
    
    private lazy var blurView: BlurView = {
        let view = BlurView()
        view.layer.cornerRadius = Size.cornerRadius
        view.clipsToBounds = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel = UILabel(
        font: Font.semibold.of(size: .header3),
        color: Color.translucent50.white
    )
    
    private lazy var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Color.translucent50.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(symbolView)
        addSubview(titleLabel)
        insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            symbolView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            symbolView.topAnchor.constraint(equalTo: topAnchor, constant: Size.Padding.normal),
            symbolView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.Padding.normal),
            
            titleLabel.leadingAnchor.constraint(equalTo: symbolView.trailingAnchor, constant: Size.Padding.half),
            titleLabel.centerYAnchor.constraint(equalTo: symbolView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with type: WeatherModel.ViewModel.Conditions.MetricsType) {
        let symbolFont = Font.semibold.of(size: .header3)
        let symbolConfig = UIImage.SymbolConfiguration(font: symbolFont)
        
        titleLabel.text = type.title
        symbolView.image = UIImage(
            systemName: type.symbolName
        )?.withConfiguration(symbolConfig)
    }
    
    func setAlpha(with offset: CGFloat) {
        titleLabel.alpha = offset
        symbolView.alpha = offset
    }
    
    func removeBlur() {
        blurView.alpha = 0
    }
    
    func addBlur() {
        blurView.alpha = 1
    }
    
    func setBackground(with offset: CGFloat) {
//        backgroundColor = .systemGray
    }
    
    //    func setHeaderOffset(with offset: CGFloat) {
    //        animatedConstraint!.constant = offset
    //    }
    //
    //    func setInitialOffset() {
    //        animatedConstraint!.constant = 0
    //    }
    
    func setAlphaForHeader(with offset: CGFloat) {
        titleLabel.alpha = offset
        symbolView.alpha = offset
    }
}
