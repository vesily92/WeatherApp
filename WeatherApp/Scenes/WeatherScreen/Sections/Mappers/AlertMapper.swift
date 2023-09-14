//
//  AlertMapper.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

final class AlertMapper {
    
    func map(_ model: WeatherData) -> [WeatherModel.Components.Alert] {
        guard let alerts = model.alerts,
              let alert = alerts.first else { return [] }
        
        let description = "\(alert.senderName): \(alert.event)"
        
        let alertViewModel = WeatherModel.Components.Alert(
            sender: alert.senderName,
            event: alert.event,
            description: description
        )
        
        return [alertViewModel]
    }
}
