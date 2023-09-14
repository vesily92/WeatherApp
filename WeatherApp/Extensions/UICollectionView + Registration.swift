//
//  UICollectionView + Registration, Dequeuing.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.03.2023.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(view: T.Type) {
        register(
            T.self,
            forSupplementaryViewOfKind: T.reuseIdentifier,
            withReuseIdentifier: T.reuseIdentifier
        )
    }
}
