//
//  Fonts.swift
//  WeatherApp
//
//  Created by Василий Пронин on 17.05.2023.
//

import UIKit

enum Font {
    case light
    case regular
    case semibold
    case bold
}

extension Font {
    func of(size: FontSize) -> UIFont {
        switch self {
        case .light:
            return .systemFont(ofSize: size.size, weight: .light)
        case .regular:
            return .systemFont(ofSize: size.size, weight: .regular)
        case .semibold:
            return .systemFont(ofSize: size.size, weight: .semibold)
        case .bold:
            return .systemFont(ofSize: size.size, weight: .bold)
        }
    }
}

enum FontSize {
    case title
    case large
    case header1
    case header2
    case header3
    case medium
    case small
    case caption
    
    var size: CGFloat {
        switch self {
        case .title: return 80
        case .large: return 44
        case .header1: return 36
        case .header2: return 32
        case .header3: return 14
        case .medium: return 20
        case .small: return 16
        case .caption: return 12
        }
    }
}
