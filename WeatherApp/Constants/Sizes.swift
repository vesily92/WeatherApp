//
//  Sizes.swift
//  WeatherApp
//
//  Created by Василий Пронин on 17.04.2023.
//

import Foundation

enum Size {
    enum Section {
        static let interSectionSpacing: CGFloat = 10
        static let inset = 20
        static let headerHeight: CGFloat = 36
    }
    
    enum Padding {
        static let half: CGFloat = 4
        static let normal: CGFloat = 8
        static let double: CGFloat = 16
        
        static let large: CGFloat = 10
        static let largeDouble: CGFloat = 20
    }
    
//    enum Element {
//        static let headerHeight: CGFloat = 36
//        static let curveWidth: CGFloat = 4
//    }
    
    static let cornerRadius: CGFloat = 16
    static let headerHeight: CGFloat = 36
    static let curveWidth: CGFloat = 4
}
