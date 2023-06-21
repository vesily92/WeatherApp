//
//  GeocodingManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 30.03.2023.
//

import Foundation

/// A type that provides geocoding information.
protocol IGeocodingManager {
    
    /// Gets geocoding information.
    /// - Parameters:
    ///   - request: Type of request (location name or coordinates).
    ///   - completion: Returns an array of ``Location`` objects on completion.
    func fetchLocation(with request: GeocodingManager.RequestType,
                       completion: @escaping ([Location]) -> Void)
}

// MARK: - GeocodingManager
/// Manager that provides geocoding information.
final class GeocodingManager {
    
    /// Type of request for geocoding service.
    enum RequestType {
        case cityName(cityName: String)
        case coordinates(latitude: Double, longitude: Double)
    }
    
    let geocodingService: IGeocodingService
    
    init(geocodingService: IGeocodingService) {
        self.geocodingService = geocodingService
    }
}

// MARK: - GeocodingManager + IGeocodingManager
extension GeocodingManager: IGeocodingManager {
    func fetchLocation(with request: GeocodingManager.RequestType,
                       completion: @escaping ([Location]) -> Void) {
        switch request {
        case .cityName(let cityName):
            geocodingService.getDirectGeocoding(withQuery: cityName) { locations in
                completion(locations)
            }
        case .coordinates(let latitude, let longitude):
            geocodingService.getReverseGeocoding(withLatitude: latitude,
                                                 andLongitude: longitude) { locations in
                completion(locations)
            }
        }
    }
}
