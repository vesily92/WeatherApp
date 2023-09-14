//
//  DailyCollectionMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 16.05.2023.
//

import Foundation

final class DailyCollectionMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(_ model: WeatherData) -> [WeatherModel.Components.DailyCollection] {
        let items = DailyMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(model)
        let dailyCollectionViewModel = WeatherModel.Components.DailyCollection(
            items: items
        )
        return [dailyCollectionViewModel]
    }
}
