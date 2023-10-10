//
//  UIColor + Interpolation.swift
//  WeatherApp
//
//  Created by Vasilii Pronin on 06.10.2023.
//

import UIKit

extension UIColor {
    
    func getComponents() -> (
        red: Double,
        green: Double,
        blue: Double,
        alpha: Double
    ) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    func interpolate(to other: UIColor, amount: Double) -> UIColor {
        let componentsFrom = self.getComponents()
        let componentsTo = other.getComponents()
        
        let newRed = (1 - amount) * componentsFrom.red + (amount * componentsTo.red)
        let newGreen = (1 - amount) * componentsFrom.green + (amount * componentsTo.green)
        let newBlue = (1 - amount) * componentsFrom.blue + (amount * componentsTo.blue)
        let newOpacity = (1 - amount) * componentsFrom.alpha + (amount * componentsTo.alpha)
        return UIColor(displayP3Red: newRed, green: newGreen, blue: newBlue, alpha: newOpacity)
    }
}
