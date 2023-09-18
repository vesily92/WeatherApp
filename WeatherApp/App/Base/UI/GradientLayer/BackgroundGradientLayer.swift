//
//  BackgroundGradientLayer.swift
//  WeatherApp
//
//  Created by Василий Пронин on 03.08.2023.
//

import UIKit

enum BackgroundType {
    case morningClear
    case morningClouds
    case dayClear
    case dayClouds
    case eveningClear
    case eveningClouds
    case nightClear
    case nightClouds
}

final class BackgroundGradientLayer: CAGradientLayer {
    
    // MARK: - Internal Methods
    
    func configure(with backgroundType: BackgroundType) {
        switch backgroundType {
        case .morningClear:
            makeMorningClearGradient()
        case .morningClouds:
            makeMorningCloudyGradient()
        case .dayClear:
            makeDayClearGradient()
        case .dayClouds:
            makeDayCloudyGradient()
        case .eveningClear:
            makeEveningClearGradient()
        case .eveningClouds:
            makeEveningCloudyGradient()
        case .nightClear:
            makeNightClearGradient()
        case .nightClouds:
            makeNightCloudyGradient()
        }
    }
   
    // MARK: - Private Methods
    
    private func makeMorningClearGradient() {
        let topColor = UIColor(
            red: 0.2,
            green: 0.3,
            blue: 0.5,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.65,
            green: 0.62,
            blue: 0.7,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeMorningCloudyGradient() {
        let topColor = UIColor(
            red: 0.46,
            green: 0.49,
            blue: 0.55,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.35,
            green: 0.38,
            blue: 0.42,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeDayClearGradient() {
        let topColor = UIColor(
            red: 0.14,
            green: 0.29,
            blue: 0.53,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.49,
            green: 0.64,
            blue: 0.83,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeDayCloudyGradient() {
        let topColor = UIColor(
            red: 0.46,
            green: 0.49,
            blue: 0.55,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.35,
            green: 0.38,
            blue: 0.42,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeEveningClearGradient() {
        let topColor = UIColor(
            red: 0.17,
            green: 0.24,
            blue: 0.41,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.62,
            green: 0.46,
            blue: 0.5,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeEveningCloudyGradient() {
        let topColor = UIColor(
            red: 0.46,
            green: 0.49,
            blue: 0.55,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.35,
            green: 0.38,
            blue: 0.42,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeNightClearGradient() {
        let topColor = UIColor(
            red: 0.02,
            green: 0.01,
            blue: 0.09,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.18,
            green: 0.22,
            blue: 0.34,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
    
    private func makeNightCloudyGradient() {
        let topColor = UIColor(
            red: 0.09,
            green: 0.12,
            blue: 0.18,
            alpha: 1
        )
        let bottomColor = UIColor(
            red: 0.15,
            green: 0.16,
            blue: 0.23,
            alpha: 1
        )
        
        colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        locations = [0.0, 1.0]
    }
}
