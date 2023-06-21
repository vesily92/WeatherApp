//
//  BaseIndicatorView.swift
//  WeatherApp
//
//  Created by Василий Пронин on 02.06.2023.
//

import UIKit

/// Abstract class for the indicator view.
class BaseIndicatorView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        
        configureLayers()
    }
    
    func configureLayers() {}
    
    /// Creates dashed circle-shaped path.
    /// - Parameters:
    ///   - segmentCount: The number of segments.
    ///   - segmentLength: The length of each segment.
    ///   - lineWidth: The width of line.
    ///   - startDegrees: Starting point in degrees of the circle.
    ///   - endDegrees: Ending point in degrees of the circle.
    /// - Returns: Bezier path object.
    func createDashedPath(
        segmentCount: Int,
        segmentLength: CGFloat,
        lineWidth: CGFloat,
        startDegrees: CGFloat = 270,
        endDegrees: CGFloat = 270 + 360
    ) -> UIBezierPath {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath()
        let maxRadius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let minRadius = maxRadius - segmentLength + lineWidth
        let startAngle = startDegrees * .pi / 180
        let endAngle = endDegrees * .pi / 180
        
        for i in 0 ... segmentCount {
            let angle = startAngle + (endAngle - startAngle) * CGFloat(i) / CGFloat(segmentCount)
            let startPoint = center.coordinates(at: angle, distance: minRadius)
            let endPoint = center.coordinates(at: angle, distance: maxRadius)
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        
        return path
    }
}
