//
//  LineIndicatorView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 17.05.2023.
//

import UIKit

final class LineIndicatorView: BaseIndicatorView {
    
    // MARK: - Constants
    
    enum LineContentType {
        case temperature(_ model: WeatherModel.Components.IndicatorViewModel)
        case uvIndex(currentPoint: CGFloat)
    }
    
    private var startPoint: CGFloat = 0
    private var endPoint: CGFloat = 1
    private var currentPoint: CGFloat?
    
    // MARK: - Private Properties
    
    private lazy var maskedView = UIView()
    private lazy var lineLayer = CAShapeLayer()
    private lazy var currentPointLayer = CAShapeLayer()
    private lazy var gradientLayer = GradientLayer()
    
    // MARK: - Overriden Methods
    
    override func configureLayers() {
        layer.cornerRadius = bounds.height / 2
        configureMaskedView()
        configureSublayers()
        
        if currentPoint != nil {
            updateMaskForCurrentPoint()
            configurePoint()
        }
    }
    
    // MARK: - Internal Methods
    
    func configure(with type: LineContentType) {
        layoutIfNeeded()
        backgroundColor = .clear
        
        switch type {
        case let .temperature(model):
            layer.backgroundColor = Color.translucent20.black.cgColor
            
            startPoint = model.startPoint
            endPoint = model.endPoint
            currentPoint = model.currentPoint
            
            gradientLayer.configure(
                with: .temperature(
                    min: model.minTemperature,
                    max: model.maxTemperature
                )
            )
        case let .uvIndex(currentPoint):
            self.currentPoint = currentPoint
            gradientLayer.configure(with: .uvIndex)
        }
        
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    private func configureMaskedView() {
        maskedView.frame = bounds
        
        maskedView.layer.addSublayer(lineLayer)
        maskedView.layer.addSublayer(gradientLayer)
        addSubview(maskedView)
    }
    
    private func configureSublayers() {
        lineLayer.lineWidth = Size.curveWidth
        lineLayer.strokeColor = Color.main.white.cgColor
        lineLayer.lineCap = CAShapeLayerLineCap.round
        lineLayer.frame = maskedView.bounds
        
        let startX = maskedView.bounds.width * startPoint
        let endX = maskedView.bounds.width * endPoint
        
        let start = CGPoint(x: startX, y: maskedView.bounds.height / 2)
        let end = CGPoint(x: endX, y: maskedView.bounds.height / 2)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        lineLayer.path = path.cgPath
        maskedView.layer.mask = lineLayer
        
        gradientLayer.frame = maskedView.bounds
        gradientLayer.mask = lineLayer
    }
    
    private func configurePoint() {
        maskedView.layer.addSublayer(currentPointLayer)
        
        currentPointLayer.lineWidth = Size.curveWidth
        currentPointLayer.strokeColor = Color.main.white.cgColor
        currentPointLayer.lineCap = .round
        currentPointLayer.frame = bounds
        
        let x = bounds.width * currentPoint! + (bounds.height / 2)
        let start = CGPoint(x: x, y: self.bounds.height / 2)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: start)
        
        currentPointLayer.path = path.cgPath
        layer.addSublayer(currentPointLayer)
    }
    
    private func updateMaskForCurrentPoint() {
        let updatedMask = CAShapeLayer()
        
        let size = maskedView.bounds.height * 2
        let x = maskedView.bounds.width * currentPoint! - size / 4
        let y: CGFloat = -maskedView.bounds.height / 2
        let rect = CGRect(x: x, y: y, width: size, height: size)
        let updatedPath = UIBezierPath(ovalIn: rect)
        
        let newPath = UIBezierPath(rect: maskedView.bounds)
        newPath.append(updatedPath)
        
        if let originalMask = maskedView.layer.mask,
           let originalShape = originalMask as? CAShapeLayer,
           let originalCGPath = originalShape.path {
            
            let originalPath = UIBezierPath(cgPath: originalCGPath)
            newPath.append(originalPath)
        }
        
        updatedMask.path = newPath.cgPath
        updatedMask.fillRule = .evenOdd
        maskedView.layer.mask = updatedMask
    }
}
