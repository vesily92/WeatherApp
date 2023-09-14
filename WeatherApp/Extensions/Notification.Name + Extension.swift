//
//  Notification.Name + Extension.swift
//  WeatherApp
//
//  Created by Василий Пронин on 08.06.2023.
//

import Foundation

enum NotificationKey {
    case viewModel
}

extension Notification.Name {
    static let updateView = Notification.Name("updateView")
}
