//
//  UILabel + ConvenienceInit.swift
//  WeatherApp
//
//  Created by Василий Пронин on 17.05.2023.
//

import UIKit

extension UILabel {
    
    convenience init(
        font: UIFont,
        color: UIColor,
        textAlignment: NSTextAlignment = .natural,
        alpha: CGFloat = 1,
        autoresizingMask: Bool = false,
        text: String? = nil
    ) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = textAlignment
        self.alpha = alpha
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = autoresizingMask
        self.text = text
    }
}
