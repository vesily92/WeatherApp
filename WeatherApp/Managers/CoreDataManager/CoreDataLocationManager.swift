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
    func delete(_ viewModel: Location)
    func reorder(_ viewModels: [Location])
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
        
        let id = "\(latitude)\(longitude)"
        let model = LocationCoreDataModel(
            id: id,
            cityName: city,
            latitude: latitude,
            longitude: longitude,
            country: viewModel.country,
            state: viewModel.state
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
                    guard let id = dbModel.id,
                          let cityName = dbModel.cityName else { return }
                    
                    let model = LocationCoreDataModel(
                        id: id,
                        cityName: cityName,
                        latitude: dbModel.latitude,
                        longitude: dbModel.longitude,
                        country: dbModel.country,
                        state: dbModel.state
                    )
                    models.append(model)
                }
                completion(.success(models))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(_ viewModel: Location) {
        coreDataService.fetch(DBLocation.self) { result in
            switch result {
            case .success(let dbModels):
                dbModels.forEach { dbModel in
                    if viewModel.id == dbModel.id {
                        coreDataService.performSave { [weak self] context in
                            self?.coreDataService.delete(
                                dbModel,
                                context: context
                            )
                        }
                    }
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reorder(_ viewModels: [Location]) {
        coreDataService.fetch(DBLocation.self) { result in
            switch result {
            case .success(let dbModels):
                dbModels.forEach { dbModel in
                    coreDataService.performSave { [weak self] context in
                        self?.coreDataService.delete(
                            dbModel,
                            context: context
                        )
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        viewModels.forEach { location in
            coreDataService.performSave { [weak self] context in
                self?.save(location)
            }
        }
    }
}
