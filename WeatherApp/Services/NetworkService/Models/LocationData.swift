//
//  LocationModel.swift
//  WeatherApp
//
//  Created by Василий Пронин on 24.03.2023.
//

struct Location: Codable, Hashable {
    let city: String?
    let latitude: Double?
    let longitude: Double?
    let country: String?
    let state: String?
    
    var fullName: String? {
        guard let city = city,
              let country = country else {
            return nil
        }
        
        var fullName = city
        if let state = state {
            fullName += ", \(state)"
        }
        fullName += ", \(country)"
        return fullName
    }
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case latitude = "lat"
        case longitude = "lon"
        case country, state
    }
}
