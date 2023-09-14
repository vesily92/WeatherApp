//
//  UVIndexDataMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 24.05.2023.
//

import Foundation

final class UVIndexDataMapper {
    
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
    
    func mapUVIndexData() -> WeatherModel.Components.Conditions {
        let currentUVI = weatherData.current.uvi.roundDecimal()
        let index = weatherFormatter.displayUVI(weatherData.current.uvi)
        let description = weatherFormatter.displayUVIDescription(currentUVI)
        
        let currentPoint = CGFloat(currentUVI / 10)
        
        let recommendation = "Fix this"
        
        let uvi = WeatherModel.Components.UVIndex(
            index: index,
            description: description,
            currentPoint: currentPoint,
            recommendation: recommendation
        )
        
        return WeatherModel.Components.Conditions(
            type: .uvIndex,
            uvIndex: uvi
        )
    }
}
