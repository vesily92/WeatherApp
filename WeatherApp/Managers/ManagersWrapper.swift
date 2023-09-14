//
//  Managers.swift
//  WeatherApp
//
//  Created by Василий Пронин on 18.06.2023.
//

import Foundation

/// A type of manager container for `SearchScreen`.
typealias ISearchScreenManagersWrapper = ICoreDataLocationManager & IMappingManager & IWeatherManager & IGeocodingManager & ILocationManager

// MARK: - SearchScreenManagersWrapper

/// Managers container object for `SearchScreen`.
struct SearchScreenManagersWrapper {
    
    let coreDataManager: ICoreDataLocationManager
    let mappingManager: IMappingManager
    let weatherManager: IWeatherManager
    let geocodingManager: IGeocodingManager
    let locationManager: ILocationManager
}

// MARK: - SearchScreenManagersWrapper + ISearchScreenManagersWrapper

extension SearchScreenManagersWrapper: ISearchScreenManagersWrapper {
    func save(_ viewModel: Location) {
        coreDataManager.save(viewModel)
    }
    
    func reorder(_ viewModels: [Location]) {
        coreDataManager.reorder(viewModels)
    }
    
    func fetch(completion: (Result<[LocationCoreDataModel], Error>) -> Void) {
        coreDataManager.fetch(completion: completion)
    }
    
    func delete(_ viewModel: Location) {
        coreDataManager.delete(viewModel)
    }
    
    func map(_ mappingDataType: MappingDataType) -> WeatherModel.ViewModel {
        mappingManager.map(mappingDataType)
    }
    
    func fetchWeatherFor(
        _ location: Location,
        completion: @escaping (WeatherModel.Response
        ) -> Void) {
        weatherManager.fetchWeatherFor(location, completion: completion)
    }
    
    func fetchLocation(
        with request: GeocodingManager.RequestType,
        completion: @escaping ([Location]) -> Void
    ) {
        geocodingManager.fetchLocation(with: request, completion: completion)
    }
    
    func getUserLocation(completion: @escaping ((Double, Double) -> Void)) {
        locationManager.getUserLocation(completion: completion)
    }
}

