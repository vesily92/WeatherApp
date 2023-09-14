//
//  GradientView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 17.05.2023.
//

import UIKit

enum GradientType {
    case temperature(min: Int, max: Int)
    case uvIndex
    case sunCurve
    case pressureRising
    case pressureFalling
    case pressureStable
}

final class GradientLayer: CAGradientLayer {
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        cornerRadius = bounds.height / 2
    }
    
    func configure(with gradientType: GradientType) {
        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
        
        switch gradientType {
        case let .temperature(min, max):
            colors = colorsForTemperatureRange(min: min, max: max)
            
        case .uvIndex:
            colors = [UIColor.systemGreen,
                      UIColor.systemYellow,
                      UIColor.systemOrange,
                      UIColor.systemRed,
                      UIColor.systemPurple].map { $0.cgColor }
            locations = [0.1, 0.3, 0.5, 0.7, 0.9]
            
        case .sunCurve:
            colors = [Color.translucent30.white,
                      Color.translucent70.white,
                      Color.translucent30.white].map { $0.cgColor }
            locations = [0.3, 0.5, 0.7]
            
        case .pressureRising:
            type = .conic
            startPoint = CGPoint(x: 0.5, y: 0.5)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            colors = [UIColor.white.withAlphaComponent(0),
                      Color.translucent70.white,
                      Color.main.white].map { $0.cgColor }
            locations = [0.4, 0.45, 0.5]
            
        case .pressureFalling:
            type = .conic
            startPoint = CGPoint(x: 0.5, y: 0.5)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            colors = [Color.main.white,
                                    Color.translucent70.white,
                                    UIColor.white.withAlphaComponent(0)].map { $0.cgColor }
            locations = [0.5, 0.55, 0.6]
            
        case .pressureStable:
            type = .conic
            startPoint = CGPoint(x: 0.5, y: 0.5)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            colors = [UIColor.white.withAlphaComponent(0),
                      Color.translucent70.white,
                      Color.main.white,
                      Color.translucent70.white,
                      UIColor.white.withAlphaComponent(0)].map { $0.cgColor }
            locations = [0.45, 0.49, 0.5, 0.51, 0.55]
        }
    }
    
    private func colorsForTemperatureRange(min: Int, max: Int) -> [CGColor] {
        let temperatureArray = Array(min...max)
        let temperatureSet = Set(min...max)
        
        guard !temperatureArray.isEmpty else { return [UIColor.white.cgColor] }
        
        var colors: [UIColor] = []
        
        let tealColorTemperatureSet = Set(0..<12)
        let yellowColorTemperatureSet = Set(12..<25)
        
        var color: UIColor = UIColor.white
        
        if temperatureArray.first! < 0 {
            color = UIColor.systemBlue
            colors.append(color)
        }
        if !temperatureSet.intersection(tealColorTemperatureSet).isEmpty {
            color = UIColor.systemTeal
            colors.append(color)
        }
        if !temperatureSet.intersection(yellowColorTemperatureSet).isEmpty {
            color = UIColor.systemYellow
            colors.append(color)
        }
        if temperatureArray.last! >= 25 {
            color = UIColor.systemOrange
            colors.append(color)
        }
        
        if colors.count < 2 {
            colors.append(color)
        }
               
        return colors.map { $0.cgColor }
    }
}
