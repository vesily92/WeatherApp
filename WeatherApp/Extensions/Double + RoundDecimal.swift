//
//  Double + Extension.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import Foundation

extension Double {
    
    func roundDecimal(
        _ scale: Int = 0,
        mode: NSDecimalNumber.RoundingMode = .plain
    ) -> Double {
        var value = Decimal(self)
        var result = Decimal()
        NSDecimalRound(&result, &value, scale, mode)
        
        return NSDecimalNumber(decimal: result).doubleValue
    }
}
