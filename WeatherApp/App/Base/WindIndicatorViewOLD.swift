//
//  WindIndicatorView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 25.05.2023.
//

import UIKit

//final class WindIndicatorView: UIView {
//
//    private lazy var windDirectionView = UIView()
//    private lazy var innerView = UIView()
//    private lazy var arrowView = UIView()
//
//    private lazy var windSpeedLabel: UILabel = {
//        let label = UILabel(
//            font: Font.semibold.of(size: .medium),
//            color: Color.main.white
//        )
//        return label
//    }()
//
//    private lazy var speedMetricsLabel: UILabel = {
//        let label = UILabel(
//            font: Font.regular.of(size: .small),
//            color: Color.main.white
//        )
//        return label
//    }()
//
//    private lazy var windLabelStack: UIStackView = {
//        let windSpeed = UILabel(
//            font: Font.semibold.of(size: .medium),
//            color: Color.main.white,
//            textAlignment: .center
//        )
//        windSpeed.text = "2"
//        let speedMetrics = UILabel(
//            font: Font.regular.of(size: .small),
//            color: Color.main.white
//        )
//        speedMetrics.text = "m/s"
//        let stack = UIStackView(arrangedSubviews: [
//            windSpeed,
//            speedMetrics
//        ])
////        [windSpeed, speedMetrics].map { stack.addSubview($0) }
//        stack.axis = .vertical
//        stack.distribution = .equalCentering
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
//
//    private lazy var upperMark = CAShapeLayer()
//
//    private var degrees: CGFloat = 45
//
//    override func draw(_ rect: CGRect) {
//        configureWindDirectionView()
//        configureInnerView()
//        configureTicksLayer()
//        configureMarkingLayer()
//                configureArrow2()
//        configureShadowCircle()
//        createDirectionLabels()
//
//        configureStackView()
////        configureArrow()
//    }
//
//    private func configureStackView() {
//        addSubview(windLabelStack)
//
//        NSLayoutConstraint.activate([
//            windLabelStack.centerXAnchor.constraint(equalTo: centerXAnchor),
//            windLabelStack.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//
//    private func configureWindDirectionView() {
//        windDirectionView.frame = bounds
//        addSubview(windDirectionView)
//
//        arrowView.frame = bounds
//        addSubview(arrowView)
//    }
//
//    private func configureInnerView() {
//        let frame = CGRect(
//            x: windDirectionView.bounds.midX / 2 - 15,
//            y: windDirectionView.bounds.midY / 2 - 15,
//            width: windDirectionView.bounds.width / 2 + 30,
//            height: windDirectionView.bounds.height / 2 + 30
//        )
//        innerView.frame = frame
////        innerView.backgroundColor = Color.translucent20.white
//        windDirectionView.addSubview(innerView)
//    }
//
//    private func configureTicksLayer() {
//        let dividingElementLength = 1.0
//        let circleLayer = CAShapeLayer()
//        circleLayer.lineWidth = Size.Element.curveWidth * 2
//        circleLayer.strokeColor = Color.translucent30.white.cgColor
//        circleLayer.fillColor = nil
//        circleLayer.lineDashPattern = calculateDashPattern(
//            numberOfPatterns: 12,
//            numberOfElements: 13,
//            dividingElementLength: dividingElementLength
//        )
//        circleLayer.frame = windDirectionView.bounds
//
//        let center = CGPoint(x: windDirectionView.bounds.width / 2, y: windDirectionView.bounds.height / 2)
//        let radius = windDirectionView.bounds.width / 2
//        let shiftRadian = (dividingElementLength / 1.4) * .pi / 180
////        let path = createCirclePath(
////            center: center,
////            radius: radius,
////            shiftRadian: shiftRadian
////        )
//        let startAngle = CGFloat(3.0 * Double.pi / 2.0)
//        let endAngle = CGFloat(7.0 * Double.pi / 2.0)
//
//        let path = UIBezierPath(
//            arcCenter: center,
//            radius: radius,
//            startAngle: startAngle - shiftRadian,
//            endAngle: endAngle - shiftRadian,
//            clockwise: true
//        )
//
//        circleLayer.path = path.cgPath
//
//        windDirectionView.layer.addSublayer(circleLayer)
//    }
//
//    private func configureMarkingLayer() {
//        let dividingElementLength = 1.0
//
//        let marksLayer = CAShapeLayer()
//        marksLayer.lineWidth = Size.Element.curveWidth * 2
//        marksLayer.strokeColor = UIColor.systemGray2.cgColor
//        marksLayer.fillColor = nil
//        marksLayer.lineDashPattern = calculateDashPattern(
//            numberOfPatterns: 4,
//            numberOfElements: 0,
//            dividingElementLength: dividingElementLength
//        )
//        marksLayer.frame = windDirectionView.bounds
//
//        let center = CGPoint(x: windDirectionView.bounds.width / 2, y: windDirectionView.bounds.height / 2)
//        let radius = windDirectionView.bounds.width / 2
//        let shiftRadian = (dividingElementLength / 1.4) * .pi / 180
////        let path = createCirclePath(
////            center: center,
////            radius: radius,
////            shiftRadian: shiftRadian
////        )
//
//        let path = UIBezierPath(
//            arcCenter: center,
//            radius: radius,
//            startAngle: 0 - shiftRadian,
//            endAngle: .pi + shiftRadian,
//            clockwise: true
//        )
//
//        marksLayer.path = path.cgPath
//
//        windDirectionView.layer.addSublayer(marksLayer)
//
////        let upperTriangleLayer = CAShapeLayer()
//        upperMark.strokeColor = nil
//        upperMark.fillColor = UIColor.systemGray2.cgColor
//        upperMark.path = createRoundedTriangle(
//            width: 9,
//            height: 8,
//            radius: 0.7
//        )
//        upperMark.position = CGPoint(
//            x: windDirectionView.bounds.midX,
//            y: 0
//        )
//        windDirectionView.layer.addSublayer(upperMark)
//    }
//
//    private func configureShadowCircle() {
//        let center = CGPoint(
//            x: innerView.bounds.width / 2,
//            y: innerView.bounds.height / 2
//        )
//        let radius = innerView.bounds.width / 3
////        let path = UIBezierPath(
////            arcCenter: center,
////            radius: radius,
////            startAngle: 0,
////            endAngle: .pi * 2,
////            clockwise: true
////        )
//        let path = createCirclePath(center: center, radius: radius)
//
//        let innerCircleLayer = CAShapeLayer()
//        innerCircleLayer.fillColor = UIColor.clear.cgColor
//        innerCircleLayer.lineWidth = Size.Element.curveWidth
//        innerCircleLayer.strokeColor = Color.main.white.cgColor
//        innerCircleLayer.path = path.cgPath
//
//        let shadowPath = UIBezierPath(
//            ovalIn: innerView.bounds.insetBy(dx: -20, dy: -20)
//        )
//        shadowPath.append(path)
//        shadowPath.usesEvenOddFillRule = true
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.fillRule = .evenOdd
//        maskLayer.path = shadowPath.cgPath
//
//        let shadowLayer = CALayer()
//        shadowLayer.shadowPath = path.cgPath
//        shadowLayer.shadowRadius = Size.Element.curveWidth
//        shadowLayer.shadowColor = Color.translucent20.black.cgColor
//        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
//        innerView.layer.addSublayer(shadowLayer)
//
//        shadowLayer.mask = maskLayer
//    }
//
//    private func calculateDashPattern(
//        numberOfPatterns: CGFloat,
//        numberOfElements: CGFloat,
//        dividingElementLength: CGFloat
//    ) -> [NSNumber] {
//        let circumference = .pi * windDirectionView.bounds.width
//        let numberOfDashes: CGFloat = numberOfElements + 1
//
//        let patternLength = (circumference / numberOfPatterns)
//        let segmentLength = (patternLength - dividingElementLength) / numberOfDashes
//        let tickLength = segmentLength / 8
//        let dashLength = (segmentLength - tickLength) + (tickLength / numberOfDashes)
//
//        let tickNum = NSNumber(value: tickLength)
//        let dashNum = NSNumber(value: dashLength)
//        let dividingElementNum = NSNumber(value: dividingElementLength)
//
//        let segment = [dashNum, tickNum]
//
//        var pattern = Array(repeating: segment, count: Int(numberOfElements)).flatMap { $0 }
//        pattern.insert(dividingElementNum, at: 0)
//        pattern.append(dashNum)
//
//        return pattern
//    }
//
////    private func configureArrow() {
////
////        let degrees = degrees - 90
////
////        let center = CGPoint(
////            x: windDirectionView.bounds.width / 2,
////            y: windDirectionView.bounds.height / 2
////        )
////        let radius = windDirectionView.bounds.width / 2 - Size.Element.curveWidth
//////        let roundPath = UIBezierPath(
//////            arcCenter: center,
//////            radius: radius,
//////            startAngle: 0,
//////            endAngle: 2 * .pi,
//////            clockwise: true
//////        )
////
//////        let roundPath = createCirclePath(center: center, radius: radius)
//////
//////        let roundMask = CAShapeLayer()
//////        roundMask.path = roundPath.cgPath
//////
//////
//////        let arrowheadLayer = CAShapeLayer()
//////
//////        let tailLayer = CAShapeLayer()
//////        tailLayer.lineWidth = Size.Element.curveWidth / 2
//////        tailLayer.strokeColor = Color.main.white.cgColor
//////        tailLayer.fillColor = nil
////
////
////        let arrowBodyLayer = CAShapeLayer()
////        arrowBodyLayer.lineWidth = Size.Element.curveWidth / 2
////        arrowBodyLayer.strokeColor = Color.main.white.cgColor
////        arrowBodyLayer.fillColor = nil
////
////        let radians = degrees * .pi / 180
//        let headX = center.x + radius * cos(radians)
//        let headY = center.y + radius * sin(radians)
////
////        let headPoint = CGPoint(x: headX, y: headY)
////
//////        let centerPoint = CGPoint(x: windDirectionView.bounds.midX, y: windDirectionView.bounds.midY)
////
////        let tailX = center.x - (headX - center.x)
////        let tailY = center.y - (headY - center.y)
////
////        let tailPoint = CGPoint(x: tailX, y: tailY)
////
////
////
////
////
////        let arrowPath = UIBezierPath()
////        arrowPath.move(to: headPoint)
////        arrowPath.addLine(to: tailPoint)
////
////        let headLayer = CAShapeLayer()
////        headLayer.lineWidth = Size.Element.curveWidth / 2
////        headLayer.strokeColor = Color.main.white.cgColor
////        headLayer.fillColor = Color.main.white.cgColor
////
////        let headPath = UIBezierPath()
////        headPath.move(to: headPoint)
////        headPath.addLine(to: CGPoint(x: headPoint.x - 3, y: headPoint.y + 2))
////        headPath.addLine(to: CGPoint(x: headPoint.x, y: headPoint.y - 5))
////        headPath.addLine(to: CGPoint(x: headPoint.x + 3, y: headPoint.y + 2))
////        headPath.addLine(to: headPoint)
////
////        headLayer.path = headPath.cgPath
//////        headLayer.setAffineTransform(CGAffineTransform(rotationAngle: radians))
////
////
////        let tailLayer = CAShapeLayer()
////        tailLayer.lineWidth = Size.Element.curveWidth / 2
////        tailLayer.strokeColor = Color.main.white.cgColor
////        tailLayer.fillColor = nil
////
////        let radiusNew = radius + Size.Element.curveWidth
////
////        let headXNew = center.x + radiusNew * cos(radians)
////        let headYNew = center.y + radiusNew * sin(radians)
////
////        let headPointNew = CGPoint(x: headXNew, y: headYNew)
////
////        let tailXNew = center.x - (headXNew - center.x)
////        let tailYNew = center.y - (headYNew - center.y)
////
////        let tailPointNew = CGPoint(x: tailXNew, y: tailYNew)
////
////        let tailPath = UIBezierPath(arcCenter: tailPointNew, radius: Size.Element.curveWidth, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
////        tailLayer.path = tailPath.cgPath
////
//////        let startAngle = CGFloat(3.0 * Double.pi / 2.0)
//////        let endAngle = startAngle + (degrees * CGFloat(Double.pi / 180))
//////
//////        let angle = startAngle + ((endAngle - startAngle) / 2.0)
//////        let startPoint = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
//////        let endPoint = CGPoint(x: center.x - radius * cos(angle), y: center.y - radius * sin(angle))
//////
//////        let arrowPath = UIBezierPath()
//////        arrowPath.move(to: startPoint)
//////        arrowPath.addLine(to: endPoint)
////
////        arrowBodyLayer.path = arrowPath.cgPath
////
////        windDirectionView.layer.addSublayer(arrowBodyLayer)
//////        windDirectionView.layer.addSublayer(headLayer)
////        windDirectionView.layer.addSublayer(tailLayer)
////
//////        var transform = CATransform3DIdentity
//////        transform = CATransform3DRotate(transform, radians, headXNew, headYNew, 1)
//////        headLayer.transform = transform
//////        var transform = CATransform3DIdentity
//////        transform = CATransform3DRotate(transform, radians, center.x, center.y, 1)
//////        arrowBodyLayer.transform = transform
//////        arrowBodyLayer.mask = roundMask
////
////        setNeedsLayout()
////    }
//
//
//
//    private func configureArrow2() {
//
////        let innerCircleLayer = CAShapeLayer()
////        let outerCircleLayer = CAShapeLayer()
//
//
//
//        let center = CGPoint(
//            x: arrowView.bounds.width / 2,
//            y: arrowView.bounds.height / 2
//        )
////        let radius = arrowView.bounds.width / 2 - Size.Element.curveWidth * 2
//
//        let arrowBodyLayer = CAShapeLayer()
//        arrowBodyLayer.lineWidth = Size.Element.curveWidth / 2
//        arrowBodyLayer.strokeColor = Color.main.white.cgColor
//        arrowBodyLayer.fillColor = nil
//
//        let radians = degrees * .pi / 180
//        let headX = arrowView.bounds.midX
//        let headY = arrowView.bounds.minY + Size.Element.curveWidth
//
//        let headPoint = CGPoint(x: headX, y: headY)
//
//        let tailX = center.x - (headX - center.x)
//        let tailY = center.y - (headY - center.y)
//
//        let tailPoint = CGPoint(x: tailX, y: tailY)
//
//        let arrowPath = UIBezierPath()
//        arrowPath.move(to: headPoint)
//        arrowPath.addLine(to: CGPoint(x: center.x, y: center.y - arrowView.bounds.height / 4 - Size.Element.curveWidth / 2))
//        arrowPath.move(to: CGPoint(x: center.x, y: center.y + arrowView.bounds.height / 4 + Size.Element.curveWidth / 2))
//        arrowPath.addLine(to: tailPoint)
//
//        let headLayer = CAShapeLayer()
//        headLayer.lineWidth = Size.Element.curveWidth / 2
//        headLayer.strokeColor = Color.main.white.cgColor
//        headLayer.fillColor = Color.main.white.cgColor
//
//        let headPath = UIBezierPath()
//        headPath.move(to: headPoint)
//        headPath.addLine(to: CGPoint(x: headPoint.x - 4, y: headPoint.y + 2))
//        headPath.addLine(to: CGPoint(x: headPoint.x, y: headPoint.y - 6))
//        headPath.addLine(to: CGPoint(x: headPoint.x + 4, y: headPoint.y + 2))
//        headPath.addLine(to: headPoint)
//        headLayer.path = headPath.cgPath
//
//        let tailLayer = CAShapeLayer()
//        tailLayer.lineWidth = Size.Element.curveWidth / 2
//        tailLayer.strokeColor = Color.main.white.cgColor
//        tailLayer.fillColor = nil
//
//        let tailCenterX = arrowView.bounds.midX
//        let tailCenterY = arrowView.bounds.maxY
//
//        let tailCenterPoint = CGPoint(x: tailCenterX, y: tailCenterY)
//
//        let tailPath = UIBezierPath(
//            arcCenter: tailCenterPoint,
//            radius: Size.Element.curveWidth,
//            startAngle: 0,
//            endAngle: 2 * .pi,
//            clockwise: true
//        )
//        tailLayer.path = tailPath.cgPath
//
//        arrowBodyLayer.path = arrowPath.cgPath
//
//        arrowView.layer.addSublayer(arrowBodyLayer)
//        arrowView.layer.addSublayer(headLayer)
//        arrowView.layer.addSublayer(tailLayer)
//
//
//        arrowView.transform = CGAffineTransform(rotationAngle: radians)
//
//        setNeedsLayout()
//    }
//
//
//
//
//
//    private func createRoundedTriangle(
//        width: CGFloat,
//        height: CGFloat,
//        radius: CGFloat
//    ) -> CGPath {
//        // Draw the triangle path with its origin at the center.
//        let point1 = CGPoint(x: -width / 2, y: height / 2)
//        let point2 = CGPoint(x: 0, y: -height / 2)
//        let point3 = CGPoint(x: width / 2, y: height / 2)
//
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 0, y: height / 2))
//        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
//        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
//        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
//        path.closeSubpath()
//
//        return path
//    }
//
//    private func createArrowPointer(
//        width: CGFloat,
//        height: CGFloat,
//        radius: CGFloat
//    ) -> CGPath {
//        // Draw the triangle path with its origin at the center.
//        let point1 = CGPoint(x: -width / 2, y: height / 2)
//        let point2 = CGPoint(x: 0, y: -height / 2)
//        let point3 = CGPoint(x: width / 2, y: height / 2)
//
//        let path = CGMutablePath()
//        path.move(to: CGPoint(x: 0, y: height / 2))
//        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
//        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
//        path.addArc(tangent1End: point3, tangent2End: point1, radius: radius)
//        path.closeSubpath()
//
//        return path
//    }
//
//    private func createCirclePath(
//        center: CGPoint,
//        radius: CGFloat,
//        shiftRadian: CGFloat = 0
//    ) -> UIBezierPath {
//
//        let startAngle = CGFloat(3.0 * Double.pi / 2.0)
//        let endAngle = CGFloat(7.0 * Double.pi / 2.0)
//
//        let path = UIBezierPath(
//            arcCenter: center,
//            radius: radius,
//            startAngle: startAngle - shiftRadian,
//            endAngle: endAngle - shiftRadian,
//            clockwise: true
//        )
//
//        return path
//    }
//
//    private func createDirectionLabels() {
//
//        let letters = ["N", "E", "S", "W"]
//
//        var angle: CGFloat = 2 * .pi
//        let step = angle / CGFloat(letters.count)
//
//        let center = CGPoint(
//            x: windDirectionView.bounds.width / 2,
//            y: windDirectionView.bounds.height / 2
//        )
//        let radius = center.x - Size.Element.curveWidth * 3
//
//        for i in 0..<letters.count {
//            let x = center.x + radius * cos(angle)
//            let y = center.y + radius * sin(angle)
//
//            let label = UILabel()
//            label.text = letters[i]
//            label.font = Font.semibold.of(size: .header3)
//            label.textColor = UIColor.systemGray3
//            label.sizeToFit()
//            label.frame.origin.x = x - label.frame.midX
//            label.frame.origin.y = y - label.frame.midY
//
//            windDirectionView.addSubview(label)
//            angle += step
//        }
//
//    }

//private func calculateDashPattern(
//    diameter: CGFloat,
//    startAngle: CGFloat = 270,
//    endAngle: CGFloat = 270 + 360,
//    elementLength: CGFloat,
//    //        dashLength: CGFloat,
//    //        numberOfPatterns: CGFloat,
//    numberOfElements: CGFloat
////) -> [NSNumber] {
//
//
//    let circumference = (.pi * (diameter / 2) / 180) * (endAngle - startAngle)
//
//    print(circumference)
//    //        let numberOfDashes: CGFloat = numberOfElements + 1
//
//    let dashLength = circumference / numberOfElements - elementLength
//
//    //        let dashLength1 = ((.pi * (diameter) / 2) - (numberOfElements * elementLength)) / (numberOfElements - 1)
//    //
//    //        print("1: \(dashLength)")
//    //        print("2: \(dashLength1)")
//    //        let patternLength = (circumference / numberOfPatterns)
//    //        let segmentLength = (patternLength - dividingElementLength) / numberOfDashes
//
//
//
//
//
//    //        let tickLength = segmentLength / 8
//    //        let dashLength = (segmentLength - tickLength) + (tickLength / numberOfDashes)
//
//    let tickNum = NSNumber(value: elementLength)
//    let dashNum = NSNumber(value: dashLength)
//    //        let dividingElementNum = NSNumber(value: dividingElementLength)
//
//    let segment = [tickNum, dashNum]
//
//    //        var pattern = Array(repeating: segment, count: Int(numberOfElements)).flatMap { $0 }
//
//    //        let halfTick = NSNumber(value: elementLength / 2)
//    //        pattern.removeFirst()
//    //        pattern.insert(halfTick, at: 0)
//    //        pattern.append(halfTick)
//    //        pattern.append(NSNumber(value: 0))
//    //        pattern.insert(dividingElementNum, at: 0)
//    //        pattern.append(dashNum)
//    //        print(pattern)
//    return segment
//}
////}
