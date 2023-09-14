//
//  WeatherNetworkService.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

/// A type that makes network calls to fetch ``WeatherData``.
protocol IWeatherService {
    
    /// Fetches ``WeatherData`` for received location..
    /// - Parameters:
    ///   - location: ``Location`` object required for network request.
    ///   - completion: Returns decoded ``WeatherData`` object on completion.
    func fetchWeather(
        for location: Location,
        completion: @escaping (WeatherData) -> Void
    )
}

/// A type that makes network calls to geocode locations.
protocol IGeocodingService {
    
    /// Receives ``Location`` object with name of the location by using geografical coordinates.
    /// - Parameters:
    ///   - latitude: Latitude.
    ///   - longitude: Longitude.
    ///   - completion: Returns decoded ``Location`` object on completion.
    func getReverseGeocoding(
        withLatitude latitude: Double,
        andLongitude longitude: Double,
        completion: @escaping ([Location]) -> Void
    )
    
    /// Receives ``Location`` object with geographical coordinates by using name of the location.
    /// - Parameters:
    ///   - query: Name of the location (city name or area name).
    ///   - completion: Returns decoded ``Location`` object on completion.
    func getDirectGeocoding(
        withQuery query: String,
        completion: @escaping ([Location]) -> Void)
    
}

// MARK: - NetworkService

/// The service object that provides networking operations.
final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
}

// MARK: - NetworkService + IWeatherService

extension NetworkService: IWeatherService {
    
    func fetchWeather(
        for location: Location,
        completion: @escaping (WeatherData) -> Void
    ) {
        guard let latitude = location.latitude,
              let longitude = location.longitude else { return }
        
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&appid=\(apiKey)&units=metric&lang=en"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response,
                  url == response.url else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherData.self, from: data)
                completion(weather)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

// MARK: - NetworkService + IGeocodingService

extension NetworkService: IGeocodingService {
    
    func getReverseGeocoding(
        withLatitude latitude: Double,
        andLongitude longitude: Double,
        completion: @escaping ([Location]) -> Void
    ) {
        let urlString = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&limit=\(1)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response,
                  url == response.url else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            guard let location = self.parseJSON(withData: data) else { return }
            completion(location)
        }
        task.resume()
    }
    
    func getDirectGeocoding(
        withQuery cityName: String,
        completion: @escaping ([Location]) -> Void
    ) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=\(5)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response,
                  url == response.url else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            guard let location = self.parseJSON(withData: data) else { return }
            completion(location)
        }
        task.resume()
    }
    
    /// Decodes received data to ``Location`` object .
    /// - Parameter data: Data object.
    /// - Returns: Array of ``Location`` objects.
    private func parseJSON(withData data: Data) -> [Location]? {
        let decoder = JSONDecoder()
        do {
            let location = try decoder.decode([Location].self, from: data)
            return location
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
