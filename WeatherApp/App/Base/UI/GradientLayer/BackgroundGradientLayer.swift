//
//  BackgroundGradientLayer.swift
//  WeatherApp
//
//  Created by Василий Пронин on 03.08.2023.
//

import UIKit

final class BackgroundGradientLayer: CAGradientLayer {
    
    struct Color {
        
        let color: UIColor
        let location: Double
    }
    
    // MARK: - Private Properties
    
    private let clearTopColors = [
        BackgroundGradientColor.clear(.top).night,
        BackgroundGradientColor.clear(.top).night,
        BackgroundGradientColor.clear(.top).sunrise,
        BackgroundGradientColor.clear(.top).day,
        BackgroundGradientColor.clear(.top).day,
        BackgroundGradientColor.clear(.top).sunset,
        BackgroundGradientColor.clear(.top).night,
        BackgroundGradientColor.clear(.top).night
    ]
    
    private let clearBottomColors = [
        BackgroundGradientColor.clear(.bottom).night,
        BackgroundGradientColor.clear(.bottom).night,
        BackgroundGradientColor.clear(.bottom).sunrise,
        BackgroundGradientColor.clear(.bottom).day,
        BackgroundGradientColor.clear(.bottom).day,
        BackgroundGradientColor.clear(.bottom).sunset,
        BackgroundGradientColor.clear(.bottom).night,
        BackgroundGradientColor.clear(.bottom).night
    ]
    
    private let cloudyTopColors = [
        BackgroundGradientColor.cloudy(.top).night,
        BackgroundGradientColor.cloudy(.top).night,
        BackgroundGradientColor.cloudy(.top).sunrise,
        BackgroundGradientColor.cloudy(.top).day,
        BackgroundGradientColor.cloudy(.top).day,
        BackgroundGradientColor.cloudy(.top).sunset,
        BackgroundGradientColor.cloudy(.top).night,
        BackgroundGradientColor.cloudy(.top).night
    ]
    
    private let cloudyBottomColors = [
        BackgroundGradientColor.cloudy(.bottom).night,
        BackgroundGradientColor.cloudy(.bottom).night,
        BackgroundGradientColor.cloudy(.bottom).sunrise,
        BackgroundGradientColor.cloudy(.bottom).day,
        BackgroundGradientColor.cloudy(.bottom).day,
        BackgroundGradientColor.cloudy(.bottom).sunset,
        BackgroundGradientColor.cloudy(.bottom).night,
        BackgroundGradientColor.cloudy(.bottom).night
    ]
    
    // MARK: - Internal Methods
    
    func configure(with model: WeatherModel.Components.BackgroundColor?) {
        guard let model = model else {
            self.colors = [
                BackgroundGradientColor.clear(.top).day,
                BackgroundGradientColor.clear(.bottom).day
            ].map { $0.cgColor }
            self.locations = [0.0, 1.0]
            
            return
        }
        
        let locations = calculateLocations(
            sunrise: model.sunrisePosition,
            sunset: model.sunsetPosition
        )
        
        var topColors: [Color] = []
        var bottomColors: [Color] = []
        
        if model.cloudy {
            topColors = getColors(for: cloudyTopColors, with: locations)
            bottomColors = getColors(for: cloudyBottomColors, with: locations)
        } else {
            topColors = getColors(for: clearTopColors, with: locations)
            bottomColors = getColors(for: clearBottomColors, with: locations)
        }
        
        let topColor = interpolateColor(
            for: model.currentPosition,
            with: topColors
        )
        let bottomColor = interpolateColor(
            for: model.currentPosition,
            with: bottomColors
        )
        
        self.colors = [
            topColor,
            bottomColor
        ].map { $0.cgColor }
        self.locations = [0.0, 1.0]
    }
    
    // MARK: - Private Methods
    
    private func getColors(
        for uiColors: [UIColor],
        with locations: [Double]
    ) -> [Color] {

        var colors: [Color] = []
        
        zip(locations, uiColors).forEach { (location, uiColor) in
            let color = Color(color: uiColor, location: location)
            colors.append(color)
        }

        return colors
    }
    
    
    
    private func calculateLocations(
        sunrise: Double,
        sunset: Double
    ) -> [Double] {
        let oneHour = 1.0 / 24.0
        
        var locations = [
            0.0,
            0.25,
            0.33,
            0.38,
            0.7,
            0.78,
            0.82,
            1.0
        ]
        
        locations[0] = 0.0
        locations[1] = sunrise - oneHour
        locations[2] = sunrise
        locations[3] = sunrise + oneHour * 2
        locations[4] = sunset - oneHour * 2
        locations[5] = sunset
        locations[6] = sunset + oneHour
        locations[7] = 1

        return locations
    }
    
    private func interpolateColor(
        for currentTime: Double,
        with colors: [Color]
    ) -> UIColor {
        
        guard let initialStop = colors.first else {
            return .white
        }
        
        var firstStop = initialStop
        var secondStop = initialStop
        
        for color in colors {
            if color.location < currentTime {
                firstStop = color
            } else {
                secondStop = color
                break
            }
        }
        
        let delta = secondStop.location - firstStop.location
        
        if delta > 0 {
            let difference = (currentTime - firstStop.location) / delta
            return firstStop.color.interpolate(
                to: secondStop.color,
                amount: difference
            )
            
        } else {
            return firstStop.color.interpolate(
                to: secondStop.color,
                amount: 0
            )
        }
    }
}
