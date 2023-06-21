//
//  BaseView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 23.03.2023.
//

import UIKit

/// Abstract class for view.
class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() { }
}
