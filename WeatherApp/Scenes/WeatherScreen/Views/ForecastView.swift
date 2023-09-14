//
//  WeatherScreenView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

final class ForecastView: BaseView {
    
    // MARK: - Private Properties
    
    private var viewModel: WeatherModel.ViewModel!
    private var collectionView: UICollectionView!
    
    private lazy var currentWeatherView: CurrentWeatherView = {
        let view = CurrentWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var adapter = CollectionViewAdapter(
        collectionView: collectionView,
        delegate: self,
        scrollDelegate: self
    )
    
    // MARK: - Overriden Methods
    
    override func setupView() {
        setupCollectionView()
        setupConstraints()
    }
    
    // MARK: - Internal Methods
    
    func configure(
        with viewModel: WeatherModel.ViewModel,
        animated: Bool = true
    ) {
        self.viewModel = viewModel
        currentWeatherView.configure(with: viewModel.current)
        adapter.makeSnapshot(animated: animated)
    }
    
    // MARK: - Private Methods
    
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
        
        NSLayoutConstraint.activate([
            currentWeatherView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: topAnchor),
            currentWeatherView.heightAnchor.constraint(equalToConstant: Size.currentWeatherViewMaxHeight)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.Padding.double),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.Padding.double),
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: Size.currentWeatherViewMinHeight),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - ForecastView + IScrollDelegate

extension ForecastView: IScrollDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentWeatherView.updateLayout(with: scrollView)
    }
}

// MARK: - ForecastView + ICollectionViewAdapterDelegate

extension ForecastView: ICollectionViewAdapterDelegate {
    func getSections() -> [Section] {
        return viewModel.sections ?? []
    }
    
    func getItemsFor(section: Section) -> [AnyHashable] {
        switch section.type {
        case .spacer:
            return [1]
        case .alert:
            return viewModel.alert ?? []
        case .hourly:
            return viewModel.hourly
        case .daily:
            return viewModel.daily
        case .conditions:
            return viewModel.conditions
        case .footer:
            return [viewModel.current]
        }
    }
}
