//
//  ConditionsMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 19.04.2023.
//

import Foundation

final class ConditionsMapper {
    
    private let dateFormatter: DateFormatter
    private let weatherFormatter: IWeatherFormatter
    
    init(dateFormatter: DateFormatter,
         weatherFormatter: IWeatherFormatter) {
        self.dateFormatter = dateFormatter
        self.weatherFormatter = weatherFormatter
    }
    
    func map(_ model: WeatherData) -> [WeatherModel.ViewModel.Conditions] {
        var conditionsViewModels: [WeatherModel.ViewModel.Conditions] = []
                
        conditionsViewModels.append(mapUVIndexData(model))
        conditionsViewModels.append(mapSunStateData(model))
        conditionsViewModels.append(mapWindData(model))
        conditionsViewModels.append(mapPrecipitationData(model))
        conditionsViewModels.append(mapFeelsLikeData(model))
        conditionsViewModels.append(mapHumidityData(model))
        conditionsViewModels.append(mapVisibilityData(model))
        conditionsViewModels.append(mapPressureData(model))
        
        return conditionsViewModels
    }
    
    private func mapUVIndexData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return UVIndexDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapUVIndexData()
    }
    
    private func mapSunStateData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return SunStateDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapSunStateData()
    }
    
    private func mapWindData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return WindDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapWindData()
    }
    
    private func mapPrecipitationData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return PrecipitationDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapPrecipitationData()
    }
    
    private func mapFeelsLikeData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return FeelsLikeDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapFeelsLikeData()
    }
    
    private func mapHumidityData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return HumidityDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapHumidityData()
    }
    
    private func mapVisibilityData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return VisibilityDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapVisibilityData()
    }
    
    private func mapPressureData(_ model: WeatherData) -> WeatherModel.ViewModel.Conditions {
        return PressureDataMapper(
            dateFormatter: dateFormatter,
            weatherFormatter: weatherFormatter,
            weatherData: model
        ).mapPressureData()
    }
}
