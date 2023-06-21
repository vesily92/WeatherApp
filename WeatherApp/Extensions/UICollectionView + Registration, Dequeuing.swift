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
    
    func dequeue<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        let id = String(describing: cell)
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: id,
            for: indexPath
        ) as? T else { fatalError() }
        
        return cell
    }
    
    func dequeue<T: UICollectionReusableView>(view: T.Type, indexPath: IndexPath) -> T {
        let id = String(describing: view)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: id,
            withReuseIdentifier: id,
            for: indexPath
        ) as? T else { fatalError() }
        
        return view
    }
}
