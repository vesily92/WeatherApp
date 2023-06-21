//
//  Notification.Name + Extension.swift
//  WeatherApp
//
//  Created by Василий Пронин on 08.06.2023.
//

import Foundation

enum NotificationKey {
    case cellIndex
    case pageIndex
}

extension Notification.Name {
    static let removeCell = Notification.Name("removeCell")
    static let scrollToPage = Notification.Name("scrollToPage")
}

