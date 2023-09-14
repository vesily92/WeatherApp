//
//  NewLocationPresenter.swift
//  WeatherApp
//
//  Created by Василий Пронин on 12.06.2023.
//

import Foundation

protocol INewLocationDelegate: AnyObject {
    
    func didAddNewLocation(with response: WeatherModel.ViewModel)
    func cancel()
}

protocol INewLocationPresenter {
    
    func setupView()
    func verifyLocations()
    func getViewModel() -> WeatherModel.ViewModel
    func handleAddButtonTap()
    func handleCancelButtonTap()
}

final class NewLocationPresenter {
    
    weak var view: INewLocationViewController?
    
    weak var delegate: INewLocationDelegate?
    
    private var viewModel: WeatherModel.ViewModel
    private let isNew: Bool
    
    init(viewModel: WeatherModel.ViewModel,
         isNew: Bool,
         delegate: INewLocationDelegate) {
        self.viewModel = viewModel
        self.isNew = isNew
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(
            forName: .updateView,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let object = notification
                .object as? [NotificationKey: WeatherModel.ViewModel],
                  let viewModel = object[NotificationKey.viewModel] else {
                return
            }
            
            self?.viewModel = viewModel
            self?.view?.render(with: viewModel)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension NewLocationPresenter: INewLocationPresenter {
    
    func setupView() {
        view?.render(with: viewModel)
    }
    
    func verifyLocations() {
        view?.setupNavigationBar(forNewLocation: isNew)
    }
    
    func getViewModel() -> WeatherModel.ViewModel {
        viewModel
    }
    
    func handleAddButtonTap() {
        delegate?.didAddNewLocation(with: viewModel)
    }
    
    func handleCancelButtonTap() {
        delegate?.cancel()
    }
}
