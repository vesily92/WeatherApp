//
//  UICollectionReusableView + ReuseIdentifier.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

