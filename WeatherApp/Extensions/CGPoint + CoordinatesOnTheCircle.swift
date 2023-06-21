//
//  CGPoint + CoordinatesOnTheCircle.swift
//  WeatherApp
//
//  Created by Василий Пронин on 31.05.2023.
//

import Foundation

extension CGPoint {
    func coordinates(at angle: CGFloat, distance: CGFloat) -> CGPoint {
        return CGPoint(x: x + distance * cos(angle), y: y + distance * sin(angle))
    }
    
    
}
