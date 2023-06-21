//
//  CoreDataLocationManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.03.2023.
//

import Foundation

protocol ICoreDataLocationManager {
    func save(_ viewModel: Location)
    func fetch(completion: (Result<[LocationCoreDataModel], Error>) -> Void)
}

final class CoreDataLocationManager {
    
    let coreDataService: ICoreDataLocationService
    
    init(coreDataService: ICoreDataLocationService) {
        self.coreDataService = coreDataService
    }
}

extension CoreDataLocationManager: ICoreDataLocationManager {
    func save(_ viewModel: Location) {
        guard let city = viewModel.city,
              let latitude = viewModel.latitude,
              let longitude = viewModel.longitude else {
            return
        }
        let model = LocationCoreDataModel(
            cityName: city,
            latitude: latitude,
            longitude: longitude
        )
        coreDataService.performSave { [weak self] context in
            self?.coreDataService.save(model, context: context)
        }
    }
    
    func fetch(completion: (Result<[LocationCoreDataModel], Error>) -> Void) {
        coreDataService.fetch(DBLocation.self) { result in
            switch result {
            case .success(let dbModels):
                var models: [LocationCoreDataModel] = []
                
                dbModels.forEach { dbModel in
                    guard let cityName = dbModel.cityName else { return }
                    
                    let model = LocationCoreDataModel(
                        cityName: cityName,
                        latitude: dbModel.latitude,
                        longitude: dbModel.longitude
                    )
                    models.append(model)
                }
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
