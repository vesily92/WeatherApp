//
//  MappingManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.07.2023.
//

import Foundation

enum MappingDataType {
    
    case complete(
        location: Location,
        weather: WeatherData,
        index: Int
    )
    case initial(
        location: Location,
        index: Int
    )
}

protocol IMappingManager {
    
    func map(_ mappingDataType: MappingDataType) -> WeatherModel.ViewModel
}

final class MappingManager {
    
    private let dateFormatter = DateFormatter()
    private let weatherFormatter = WeatherFormatter()
    private let sectionsManager = ManagerAssembly().weatherScreenSectionManager
    
    private func getCurrent(
        location: Location,
        weather: WeatherData? = nil
    ) -> WeatherModel.Components.Current {
        return CurrentMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(weather, location: location)
    }
    
    private func getListLocation(
        location: Location,
        index: Int,
        weather: WeatherData? = nil
    ) -> WeatherModel.Components.Current {
        return SearchScreenMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(location: location, weather: weather, index: index)
    }
    
    private func getAlert(
        weather: WeatherData
    ) -> [WeatherModel.Components.Alert] {
        return AlertMapper().map(weather)
    }
    
    private func getHourly(
        weather: WeatherData
    ) -> [WeatherModel.Components.Hourly] {
        return HourlyMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(weather)
    }
    
    private func getDaily(
        weather: WeatherData
    ) -> [WeatherModel.Components.DailyCollection] {
        return DailyCollectionMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(weather)
    }
    
    private func getConditions(
        weather: WeatherData
    ) -> [WeatherModel.Components.Conditions] {
        return ConditionsMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter
        ).map(weather)
    }
    
    private func mapForCompleteData(
        location: Location,
        weather: WeatherData,
        index: Int
    ) -> WeatherModel.ViewModel {
        let current = getCurrent(location: location, weather: weather)
        let list = getListLocation(
            location: location,
            index: index,
            weather: weather
        )
        let hourly = getHourly(weather: weather)
        let daily = getDaily(weather: weather)
        let conditions = getConditions(weather: weather)
        let alert = getAlert(weather: weather)
        
        let sections = sectionsManager.createSectionsWith(
            location: location,
            weatherData: weather
        )
        
        return WeatherModel.ViewModel(
            location: location,
            list: list,
            current: current,
            hourly: hourly,
            daily: daily,
            conditions: conditions,
            alert: alert,
            sections: sections
        )
    }
    
    private func mapForInitialData(
        location: Location,
        index: Int
    ) -> WeatherModel.ViewModel {
        let current = getCurrent(location: location)
        let list = getListLocation(
            location: location,
            index: index
        )
        
        return WeatherModel.ViewModel(
            location: location,
            list: list,
            current: current,
            hourly: [],
            daily: [],
            conditions: [],
            alert: nil,
            sections: nil
        )
    }
}

extension MappingManager: IMappingManager {
    
    func map(_ mappingDataType: MappingDataType) -> WeatherModel.ViewModel {
        switch mappingDataType {
            
        case .complete(let location, let weather, let index):
            return mapForCompleteData(
                location: location,
                weather: weather,
                index: index
            )
            
        case .initial(let location, let index):
            return mapForInitialData(location: location, index: index)
        }
    }
}
