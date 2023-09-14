//
//  ConditionCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import UIKit

final class ConditionCell: BaseCell {
    
    private lazy var blurView: BlurView = {
        let view = BlurView()
        view.layer.cornerRadius = Size.cornerRadius
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerMask: UIView = {
        let maskView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: contentView.frame.width,
                height: contentView.frame.height
            )
        )
        maskView.backgroundColor = .green
        maskView.layer.cornerRadius = Size.cornerRadius
        return maskView
    }()
    
    private lazy var headerView: ConditionHeader = {
        let view = ConditionHeader()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var animatedConstraint: NSLayoutConstraint?
    
    private lazy var conditionView: ConditionView = {
        let view = ConditionView()
        view.layer.cornerRadius = Size.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupCell() {
        setupConstraints()
    }
        
    func configure(with model: WeatherModel.ViewModel.Conditions) {
        headerView.configure(with: model.type)
        conditionView.configure(with: model)
    }
    
    func setHeaderOffset(with offset: CGFloat) {
        animatedConstraint!.constant = offset
    }
    
    func setMask(with margin: CGFloat) {
        conditionView.makeMask(for: margin)
    }
    
    func setHeaderMask(with offset: CGFloat) {
        contentView.mask = headerMask
        headerMask.frame = CGRect(x: 0, y: offset, width: contentView.frame.width, height: contentView.frame.height)
    }
    
    func setAlphaForHeader(with offset: CGFloat) {
        headerView.alpha = offset
    }
    
    func removeBlur() {
        blurView.removeFromSuperview()
        headerView.addBlur()
    }
    
    func setBlur() {
        headerView.removeBlur()
        contentView.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
            
    private func setupConstraints() {
        
        contentView.addSubview(conditionView)
        contentView.addSubview(headerView)
        contentView.insertSubview(blurView, at: 0)
        
        animatedConstraint = headerView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Size.headerHeight),
            animatedConstraint!
        ])
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            conditionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            conditionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            conditionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            conditionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

