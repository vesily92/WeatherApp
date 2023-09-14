//
//  WeatherScreenView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class ForecastView: BaseView {
    
    private let minHeight: CGFloat = 140
    private let maxHeight: CGFloat = 350
    private var animatedConstraint: NSLayoutConstraint?
    private var offsetY: CGFloat = 0
    
    private var sections: [Section]? {
        didSet { adapter.makeSnapshot(animated: true) }
    }
    
    private lazy var currentWeatherView: CurrentWeatherView = {
        let view = CurrentWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var collectionView: UICollectionView!
    private lazy var adapter = CollectionViewAdapter(
        delegate: self,
        collectionView: collectionView,
        scrollDelegate: self
    )
    
    override func setupView() {
        setupCollectionView()
        setupConstraints()
    }
    
    func configure(with viewModel: WeatherModel.ViewModel.WeatherScreen) {
        currentWeatherView.configure(with: viewModel.current)
        sections = viewModel.sections
    }
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let newFrame = collectionView.frame.insetBy(dx: -32, dy: -350)
//        if newFrame.contains(point) {
//            return collectionView
//        }
//        return super.hitTest(point, with: event)
//    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = Size.cornerRadius
        collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        addSubview(currentWeatherView)
        addSubview(collectionView)
        
        animatedConstraint = currentWeatherView.heightAnchor.constraint(equalToConstant: maxHeight)
        
        NSLayoutConstraint.activate([
            currentWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: topAnchor),
            animatedConstraint!
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            collectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

extension ForecastView: ICollectionViewAdapterDelegate {
    func sectionsForCollectionView() -> [Section] {
        guard let sections = sections else { return [] }
        return sections
    }
}

extension ForecastView: IScrollDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {        
        let currentOffsetY = scrollView.contentOffset.y
        let scrollDelta = currentOffsetY - offsetY
        let bounceBorder = -scrollView.contentInset.top
        
        let scrollsUp = scrollDelta > 0 && currentOffsetY > bounceBorder
        let scrollsDown = scrollDelta < 0 && currentOffsetY < bounceBorder
        
        let currentConstraintHeight = animatedConstraint!.constant
        var newConstraintHeight = currentConstraintHeight
        
        if scrollsUp {
            newConstraintHeight = max(currentConstraintHeight - scrollDelta, minHeight)
        } else if scrollsDown {
            newConstraintHeight = min(currentConstraintHeight - scrollDelta, maxHeight)
        }

        if newConstraintHeight != currentConstraintHeight {
            animatedConstraint?.constant = newConstraintHeight
            currentWeatherView.setLayout(with: currentOffsetY)
            scrollView.contentOffset.y = offsetY
        }
//        let completionPercentage = (maxHeight - currentConstraintHeight) / (maxHeight - minHeight)
//        print(completionPercentage)
        offsetY = scrollView.contentOffset.y
        
    }
}
