//
//  PressureIndicatorView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 30.05.2023.
//

import UIKit

final class PressureIndicatorView: BaseIndicatorView {
    
    private lazy var pressureView = UIView()
    private lazy var pointerView = UIView()
    
    private let markingWidth = Size.curveWidth * 3
    private var state: WeatherModel.ViewModel.Pressure.State = .stable
    private var degrees: Double = 0
    
    override func configureLayers() {
        configureViews()
        
        configurePressureLayer()
        configurePointerLayer()
        
        configureGradient(with: state)
        
        let radians = CGFloat(degrees) * .pi / 180
        pointerView.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    func configure(with model: WeatherModel.ViewModel.Pressure) {
        layoutIfNeeded()
        
        state = model.state
        degrees = model.rotationDegrees
        
        backgroundColor = .clear
        setNeedsLayout()
    }
    
    private func configureViews() {
        pressureView.frame = bounds
        pointerView.frame = bounds
        
        addSubview(pressureView)
        addSubview(pointerView)
    }
    
    private func configurePressureLayer() {
        let lineWidth: CGFloat = 2.0
        let pressureLayer = CAShapeLayer()
        pressureLayer.lineWidth = lineWidth
        pressureLayer.strokeColor = Color.translucent20.white.cgColor
        pressureLayer.fillColor = nil

        let path = createDashedPath(
            segmentCount: 42,
            segmentLength: markingWidth,
            lineWidth: lineWidth,
            startDegrees: 145,
            endDegrees: 395
        )
        
        pressureLayer.path = path.cgPath
        pressureView.layer.addSublayer(pressureLayer)
    }
    
    private func configurePointerLayer() {
        let pointerLayer = CAShapeLayer()
        pointerLayer.lineWidth = markingWidth / 3
        pointerLayer.lineCap = .round
        pointerLayer.strokeColor = Color.main.white.cgColor
        
        let startPoint = CGPoint(
            x: pressureView.bounds.midX,
            y: pressureView.bounds.minY + markingWidth
        )
        
        let endPoint = CGPoint(
            x: pressureView.bounds.midX,
            y: pressureView.bounds.minY
        )
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        pointerLayer.path = path.cgPath
        pointerView.layer.addSublayer(pointerLayer)
    }
            
    private func configureGradient(with state: WeatherModel.ViewModel.Pressure.State) {
        let gradientLayer = GradientLayer()
        gradientLayer.frame = pointerView.bounds

        var startAngle: CGFloat = 0
        var endAngle: CGFloat = 0
        
        switch state {
        case .rising:
            startAngle = 144 * .pi / 180
            endAngle = 270 * .pi / 180
            
            gradientLayer.configure(with: .pressureRising)
            
        case .falling:
            startAngle = 270 * .pi / 180
            endAngle = 36 * .pi / 180
            
            gradientLayer.configure(with: .pressureFalling)
            
        case .stable:
            startAngle = 144 * .pi / 180
            endAngle = 36 * .pi / 180
            
            gradientLayer.configure(with: .pressureStable)
        }
        
        let path = UIBezierPath(
            arcCenter: CGPoint(
                x: pointerView.bounds.width / 2,
                y: pointerView.bounds.height / 2
            ),
            radius: pointerView.bounds.width / 2 - markingWidth / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        let mask = CAShapeLayer()
        mask.fillColor = Color.main.clear.cgColor
        mask.strokeColor = Color.translucent50.white.cgColor
        mask.lineWidth = markingWidth
        mask.path = path.cgPath
        gradientLayer.mask = mask
        
        pointerView.layer.addSublayer(gradientLayer)
    }
}
