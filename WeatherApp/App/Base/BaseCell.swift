//
//  BaseCell.swift
//  WeatherApp
//
//  Created by Василий Пронин on 11.04.2023.
//

import UIKit

/// A type that is able to apply mask.
protocol IMaskable: UIView {
    
    /// Creates mask.
    /// - Parameter margin: The margin size for the mask.
    func makeMask(for margin: CGFloat)
}

// MARK: - BaseCell

/// Abstract class for collection view cell.
class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() { }
    
    /// Creates gradient layer for masking.
    /// - Parameter location: Location for the mask.
    /// - Returns: Gradient layer object.
    private func setAlphaMask(with location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = contentView.bounds
        mask.colors = [UIColor.white.withAlphaComponent(0),
                       UIColor.white].map { $0.cgColor }
        
        let num = location as NSNumber
        mask.locations = [num, num]
        return mask
    }
}

// MARK: - BaseCell + IMaskable

extension BaseCell: IMaskable {
    
    func makeMask(for margin: CGFloat) {
        layer.mask = setAlphaMask(with: margin / frame.size.height)
        layer.masksToBounds = true
    }
}
