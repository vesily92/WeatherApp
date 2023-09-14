//
//  VisibilityDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 01.06.2023.
//

import Foundation

final class VisibilityDataMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    private let weatherData: WeatherData
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter,
         weatherData: WeatherData) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
        self.weatherData = weatherData
    }
    
    func mapVisibilityData() -> WeatherModel.Components.Conditions {
        let visibilityKM = weatherData.current.visibility / 1000
        
        let distance = "\(visibilityKM) km"
        let description = "It's perfectly clear right now."
        
        let visibility = WeatherModel.Components.Visibility(
            distance: distance,
            description: description
        )
        
        return WeatherModel.Components.Conditions(
            type: .visibility,
            visibility: visibility
        )
    }
}
