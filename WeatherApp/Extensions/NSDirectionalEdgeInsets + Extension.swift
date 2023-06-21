//
//  NSDirectionalEdgeInsets + Extension.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func horizontal(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: size, bottom: 0, trailing: size)
    }
    
    static func trailing(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: size)
    }
}
