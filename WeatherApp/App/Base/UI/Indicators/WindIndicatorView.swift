//
//  WindIndicatorView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 30.05.2023.
//

import UIKit

final class WindIndicatorView: BaseIndicatorView {
    
    // MARK: - Constants
    
    private let markupWidth = Size.curveWidth * 1.5
    private let arrowWidth = Size.curveWidth / 2
    private var degrees: Int = 0
    
    // MARK: - Private Properties
    
    private lazy var markupView = UIView()
    private lazy var arrowView = UIView()
    private lazy var shadowView = UIView()
    
    // MARK: - Overriden Methods
    
    override func configureLayers() {
        setupViews()
        
        configureMarkupViewLayers()
        configureShadowLayer()
        configureArrowLayer()
        
        locateLabelsInCircle(
            on: markupView,
            content: ["E", "S", "W", "N"],
            padding: markupWidth * 2.5
        )
        
        let radians = CGFloat(degrees) * .pi / 180
        arrowView.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    // MARK: - Internal Methods
    
    /// Configures view
    /// - Parameter model: view model
    func configure(with model: WeatherModel.Components.Wind) {
        layoutIfNeeded()
        
        degrees = model.degrees
        
        backgroundColor = .clear
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        markupView.frame = bounds
        arrowView.frame = bounds
        let innerViewFrame = CGRect(
            x: bounds.width / 4,
            y: bounds.height / 4,
            width: bounds.width / 2,
            height: bounds.height / 2
        )
        shadowView.frame = innerViewFrame
        
        addSubview(markupView)
        addSubview(arrowView)
        addSubview(shadowView)
    }
    
    private func configureMarkupViewLayers() {
        let tickLineWidth: CGFloat = 0.5
        let tickCount = 168
        
        let tickLayer = CAShapeLayer()
        tickLayer.lineWidth = tickLineWidth
        tickLayer.strokeColor = Color.translucent30.white.cgColor
        
        let tickPath = createDashedPath(
            segmentCount: tickCount,
            segmentLength: markupWidth,
            lineWidth: tickLineWidth
        )
        
        tickLayer.frame = markupView.bounds
        tickLayer.path = tickPath.cgPath
        
        let markupLineWidth: CGFloat = 1.0
        let marksCount = 2
        
        let markupLayer = CAShapeLayer()
        markupLayer.lineWidth = markupLineWidth
        markupLayer.strokeColor = UIColor.systemGray3.cgColor
        
        let markingPath = createDashedPath(
            segmentCount: marksCount,
            segmentLength: markupWidth,
            lineWidth: markupLineWidth,
            startDegrees: 0,
            endDegrees: 180
        )
        
        markupLayer.frame = markupView.bounds
        markupLayer.path = markingPath.cgPath
        
        let triangleMarkLayer = CAShapeLayer()
        triangleMarkLayer.strokeColor = nil
        triangleMarkLayer.fillColor = UIColor.systemGray2.cgColor
        triangleMarkLayer.path = createRoundedTriangle(
            width: markupWidth + 2,
            height: markupWidth,
            radius: markupWidth / 10
        )
        
        triangleMarkLayer.position = CGPoint(
            x: markupView.bounds.midX,
            y: markupView.bounds.minY + markupWidth / 2
        )
        
        markupView.layer.addSublayer(tickLayer)
        markupView.layer.addSublayer(markupLayer)
        markupView.layer.addSublayer(triangleMarkLayer)
    }
    
    private func configureArrowLayer() {
        arrowView.layer.sublayers?.removeAll()
        
        let lineWidth: CGFloat = 2
        let color = Color.main.white.cgColor
        
        let center = CGPoint(
            x: arrowView.bounds.width / 2,
            y: arrowView.bounds.height / 2
        )
        
        let startX = center.x
        let startY = arrowView.bounds.minY + markupWidth - lineWidth / 2
        let startPoint = CGPoint(x: startX, y: startY)
        
        let arrowHead = configureArrowHead(
            lineWidth: lineWidth,
            strokeColor: color,
            startPoint: startPoint
        )
        let arrowBody = configureArrowBody(
            lineWidth: lineWidth,
            strokeColor: color,
            startPoint: startPoint,
            center: center
        )
        let arrowTail = configureArrowTail(
            lineWidth: lineWidth,
            strokeColor: color
        )
        
        arrowView.layer.addSublayer(arrowHead)
        arrowView.layer.addSublayer(arrowBody)
        arrowView.layer.addSublayer(arrowTail)
    }
    
    private func configureArrowHead(
        lineWidth: CGFloat,
        strokeColor: CGColor,
        startPoint: CGPoint
    ) -> CAShapeLayer {
        let arrowHeadLayer = CAShapeLayer()
        arrowHeadLayer.lineWidth = lineWidth
        arrowHeadLayer.strokeColor = strokeColor
        arrowHeadLayer.fillColor = strokeColor
        
        let path = createArrowPath(startPoint: startPoint, lineWidth: lineWidth)
        
        arrowHeadLayer.path = path.cgPath
        arrowHeadLayer.frame = arrowView.bounds
        
        return arrowHeadLayer
    }
    
    private func configureArrowBody(
        lineWidth: CGFloat,
        strokeColor: CGColor,
        startPoint: CGPoint,
        center: CGPoint
    )  -> CAShapeLayer {
        let x = center.x - (startPoint.x - center.x)
        let y = center.y - (startPoint.y - center.y)
        let endPoint = CGPoint(x: x, y: y)
        
        let arrowBodyLayer = CAShapeLayer()
        arrowBodyLayer.lineWidth = lineWidth
        arrowBodyLayer.strokeColor = strokeColor
        arrowBodyLayer.fillColor = strokeColor
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: center.x, y: shadowView.frame.minY))
        path.move(to: CGPoint(x: center.x, y: shadowView.frame.maxY))
        path.addLine(to: endPoint)
        
        arrowBodyLayer.path = path.cgPath
        arrowBodyLayer.frame = arrowView.bounds
        
        return arrowBodyLayer
    }
    
    private func configureArrowTail(
        lineWidth: CGFloat,
        strokeColor: CGColor
    ) -> CAShapeLayer {
        let arrowTailLayer = CAShapeLayer()
        arrowTailLayer.lineWidth = lineWidth
        arrowTailLayer.strokeColor = strokeColor
        arrowTailLayer.fillColor = nil
        
        let x = arrowView.bounds.midX
        let y = arrowView.bounds.maxY - markupWidth / 2
        let center = CGPoint(x: x, y: y)
        
        let path = UIBezierPath(
            arcCenter: center,
            radius: markupWidth / 2,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        arrowTailLayer.path = path.cgPath
        arrowTailLayer.frame = arrowView.bounds
        
        return arrowTailLayer
    }
    
    private func configureShadowLayer() {
        let path =  UIBezierPath(
            arcCenter: CGPoint(
                x: shadowView.bounds.width / 2,
                y: shadowView.bounds.height / 2
            ),
            radius: shadowView.bounds.width / 2,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        
        let shadowPath = UIBezierPath(
            ovalIn: shadowView.bounds.insetBy(dx: -20, dy: -20)
        )
        shadowPath.append(path)
        shadowPath.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.path = shadowPath.cgPath
        
        let shadowLayer = CALayer()
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowRadius = Size.curveWidth
        shadowLayer.shadowColor = Color.translucent20.black.cgColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.addSublayer(shadowLayer)
        
        shadowLayer.mask = maskLayer
    }
}

// MARK: - WindIndicatorView + Extension

extension WindIndicatorView {
    
    private func locateLabelsInCircle(
        on view: UIView,
        content: [String],
        padding: CGFloat
    ) {
        var angle: CGFloat = 2 * .pi
        let step = angle / CGFloat(content.count)
        
        let center = CGPoint(
            x: view.bounds.width / 2,
            y: view.bounds.height / 2
        )
        let radius = center.x - padding
        
        for i in 0..<content.count {
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            let label = UILabel()
            label.text = content[i]
            label.textAlignment = .right
            label.font = Font.semibold.of(size: .header3)
            label.textColor = UIColor.systemGray3
            label.sizeToFit()
            label.frame.origin.x = x - label.frame.midX
            label.frame.origin.y = y - label.frame.midY
            
            view.addSubview(label)
            angle += step
        }
    }
    
    private func createRoundedTriangle(
        width: CGFloat,
        height: CGFloat,
        radius: CGFloat
    ) -> CGPath {
        let point1 = CGPoint(x: -width / 2, y: height / 2)
        let point2 = CGPoint(x: 0, y: -height / 2)
        let point3 = CGPoint(x: width / 2, y: height / 2)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
        path.closeSubpath()
        
        return path
    }
    
    private func createArrowPath(
        startPoint: CGPoint,
        lineWidth: CGFloat
    ) -> UIBezierPath {
        let leftPoint = CGPoint(
            x: startPoint.x - markupWidth / 2,
            y: startPoint.y + lineWidth
        )
        let topPoint = CGPoint(
            x: startPoint.x,
            y: startPoint.y - markupWidth + lineWidth
        )
        let rightPoint = CGPoint(
            x: startPoint.x + markupWidth / 2,
            y: startPoint.y + lineWidth
        )
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: leftPoint)
        path.addLine(to: topPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: startPoint)
        
        return path
    }
}
