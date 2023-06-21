//
//  SunIndicatorView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 20.05.2023.
//

import UIKit

final class SunIndicatorView: BaseIndicatorView {
    
    private lazy var daytimeView = UIView()
    
    private var percentage: Double! = 0.8
    
    private lazy var curveStart: CGPoint = {
        let point = CGPoint(
            x: 0,
            y: bounds.maxY - (bounds.height / 6)
        )
        return point
    }()
    
    private lazy var curveCenter: CGPoint = {
        let point = CGPoint(
            x: bounds.midX,
            y: bounds.minY + (bounds.height / 4)
        )
        return point
    }()
    
    private lazy var curveEnd: CGPoint = {
        let point = CGPoint(
            x: bounds.maxX,
            y: bounds.maxY - (bounds.height / 6)
        )
        return point
    }()
    
    override func configureLayers() {
        configureCurve()
        configureDaytimeView()
        configureSeparator()
        
        configureNightPoint()
        configureDayPoint()
    }
    
    func configure(with percentage: Double) {
        layoutIfNeeded()
        
        self.percentage = percentage
        
        backgroundColor = .clear
        setNeedsLayout()
    }
    
    private func configureCurve() {
        let curveLayer = CAShapeLayer()
        layer.addSublayer(curveLayer)
        curveLayer.lineWidth = Size.curveWidth
        curveLayer.fillColor = nil
        curveLayer.strokeColor = Color.translucent20.black.cgColor
        curveLayer.frame = bounds
        
        let path = createCurvePath()
        curveLayer.path = path.cgPath
    }
    
    private func configureDaytimeView() {
        daytimeView.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: bounds.height / 1.6
        )
        addSubview(daytimeView)
        
        let sunriseLayer = CAShapeLayer()
        let path = createCurvePath()

        sunriseLayer.lineWidth = Size.curveWidth
        sunriseLayer.fillColor = nil
        sunriseLayer.strokeColor = Color.main.white.cgColor
        sunriseLayer.frame = daytimeView.bounds
        
        sunriseLayer.path = path.cgPath
        
        let gradientLayer = GradientLayer()
        gradientLayer.configure(with: .sunCurve)
        gradientLayer.frame = daytimeView.bounds
        daytimeView.layer.addSublayer(gradientLayer)
        daytimeView.layer.mask = sunriseLayer
    }
    
    private func configureSeparator() {
        let separator = UIView()
        separator.frame = CGRect(
            x: 0,
            y: daytimeView.bounds.maxY - 1,
            width: bounds.width,
            height: 1
        )
        separator.backgroundColor = .white
        addSubview(separator)
    }
    
    private func configureDayPoint() {
        let lightPoint = CAShapeLayer()
        lightPoint.lineWidth = 0.4
        lightPoint.strokeColor = Color.main.white.cgColor
        lightPoint.fillColor = Color.main.white.cgColor
        lightPoint.frame = bounds
        
        lightPoint.shadowRadius = Size.curveWidth
        lightPoint.shadowOffset = .zero
        lightPoint.shadowOpacity = 1
        lightPoint.shadowColor = Color.main.white.cgColor
        
        let path = createCirclePath().cgPath
        lightPoint.path = path
        lightPoint.shadowPath = path
        layer.addSublayer(lightPoint)
        
        let sunLayer = CAShapeLayer()
        layer.addSublayer(lightPoint)
        sunLayer.frame = daytimeView.bounds
        sunLayer.cornerRadius = sunLayer.bounds.height / 2
        sunLayer.backgroundColor = Color.main.white.cgColor
        
        lightPoint.mask = sunLayer
    }
    
    private func configureNightPoint() {
        let path = createCirclePath().cgPath
        
        let darkPoint = CAShapeLayer()
        darkPoint.lineWidth = 0.4
        darkPoint.strokeColor = Color.main.white.cgColor
        darkPoint.fillColor = Color.main.black.cgColor
        darkPoint.frame = bounds
        darkPoint.path = path
        
        layer.addSublayer(darkPoint)
    }
    
    private func createCurvePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: curveStart)
        path.addCurve(
            to: curveCenter,
            controlPoint1: CGPoint(x: curveStart.x + 30, y: curveStart.y),
            controlPoint2: CGPoint(x: curveCenter.x - 30, y: curveCenter.y)
        )
        path.addCurve(
            to: curveEnd,
            controlPoint1: CGPoint(x: curveCenter.x + 30, y: curveCenter.y),
            controlPoint2: CGPoint(x: curveEnd.x - 30, y: curveEnd.y)
        )
        
        return path
    }
    
    private func createCirclePath() -> UIBezierPath {
        let controlPoint1 = CGPoint(x: curveStart.x + 30, y: curveStart.y)
        let controlPoint2 = CGPoint(x: curveCenter.x - 30, y: curveCenter.y)
        let controlPoint3 = CGPoint(x: curveCenter.x + 30, y: curveCenter.y)
        let controlPoint4 = CGPoint(x: curveEnd.x - 30, y: curveEnd.y)
        
        let diameter: CGFloat = 10
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        let t = percentage * 2
                
        if t <= 1 {
            x = bezierInterpolation(
                t: t,
                p1: curveStart.x,
                cp1: controlPoint1.x,
                cp2: controlPoint2.x,
                p2: curveCenter.x
            )
            
            y = bezierInterpolation(
                t: t,
                p1: curveStart.y,
                cp1: controlPoint1.y,
                cp2: controlPoint2.y,
                p2: curveCenter.y
            )
        } else {
            let secondT = t - 1
            x = bezierInterpolation(
                t: secondT,
                p1: curveCenter.x,
                cp1: controlPoint3.x,
                cp2: controlPoint4.x,
                p2: curveEnd.x
            )
            
            y = bezierInterpolation(
                t: secondT,
                p1: curveCenter.y,
                cp1: controlPoint3.y,
                cp2: controlPoint4.y,
                p2: curveEnd.y
            )
        }
        
        let rect = CGRect(
            x: x - (diameter / 2),
            y: y - (diameter / 2),
            width: diameter,
            height: diameter
        )
        
        return UIBezierPath(ovalIn: rect)
    }
}

extension SunIndicatorView {
    func bezierInterpolation(t: CGFloat, p1: CGFloat, cp1: CGFloat, cp2: CGFloat, p2: CGFloat) -> CGFloat {
        let t2: CGFloat = t * t;
        let t3: CGFloat = t2 * t;
        return p1 + (-p1 * 3 + t * (3 * p1 - p1 * t)) * t
        + (3 * cp1 + t * (-6 * cp1 + cp1 * 3 * t)) * t
        + (cp2 * 3 - cp2 * 3 * t) * t2
        + p2 * t3;
    }
}
