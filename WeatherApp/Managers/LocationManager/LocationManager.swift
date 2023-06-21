//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import CoreLocation

/// A type that provides user location.
protocol ILocationManager {
    
    /// Gets user location.
    /// - Parameter completion: Returns latitude and longitude on completion.
    func getUserLocation(completion: @escaping ((Double, Double) -> Void))
}

// MARK: - LocationManager
/// Manager that fetches user location.
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Properties
    private let manager = CLLocationManager()
    private var completion: ((Double, Double) -> Void)?
    
    // MARK: - Internal methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        completion?(latitude, longitude)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(String(describing: error))
    }
}

// MARK: - LocationManager + ILocationManager
extension LocationManager: ILocationManager {
    func getUserLocation(completion: @escaping ((Double, Double) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
}
