//
//  NewLocationViewController.swift
//  WeatherApp
//
//  Created by Василий Пронин on 15.06.2023.
//

import UIKit

protocol INewLocationViewController: AnyObject {
    
    func render(with viewModel: WeatherModel.ViewModel)
    func setupNavigationBar(forNewLocation: Bool)
}

final class NewLocationViewController: UIViewController {
    
    var presenter: INewLocationPresenter!
    private lazy var forecastView = ForecastView()
    private lazy var backgroundGradient = BackgroundGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundGradient.configure(
            with: presenter
                .getViewModel()
                .current
                .backgroundColor
        )
        backgroundGradient.frame = view.bounds
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        presenter.setupView()
        presenter.verifyLocations()
        setupConstraints()
    }
    
    private func setupConstraints() {
        forecastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forecastView)
        
        NSLayoutConstraint.activate([
            forecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastView.topAnchor.constraint(equalTo: view.topAnchor),
            forecastView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addNewLocation() {
        presenter.handleAddButtonTap()
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        presenter.handleCancelButtonTap()
        dismiss(animated: true)
    }
}

// MARK: - NewLocationViewController + INewLocationViewController

extension NewLocationViewController: INewLocationViewController {
    
    func render(with viewModel: WeatherModel.ViewModel) {
        DispatchQueue.main.async {
            self.forecastView.configure(with: viewModel)
            self.backgroundGradient.configure(
                with: viewModel.current.backgroundColor
            )
        }
    }
    
    func setupNavigationBar(forNewLocation isNew: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
        if isNew {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Add",
                style: .done,
                target: self,
                action: #selector(addNewLocation)
            )
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
}
