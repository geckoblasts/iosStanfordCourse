//
//  GraphView.swift
//  StackCalculator
//
//  Created by Jacob Grud Mulvad on 09/08/15.
//  Copyright (c) 2015 Jacob Mulvad. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    
    var origin: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    @IBInspectable
    var axesColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var graphColor: UIColor = UIColor.greenColor() { didSet { setNeedsDisplay() } }
    
    
    
    @IBInspectable
    var scale: CGFloat = 10 { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect)
    {
        let coordinateSystem = AxesDrawer(color: UIColor.blueColor(), contentScaleFactor: 1.0)
                
        coordinateSystem.color = axesColor
        
        coordinateSystem.drawAxesInRect(rect, origin: origin, pointsPerUnit: scale)
        
        let graphPath = UIBezierPath()
        graphPath.lineWidth = lineWidth
        var firstValue = true
        var point = CGPoint()
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    continue
                }
                point.y = origin.y - y * scale
                if firstValue {
                    graphPath.moveToPoint(point)
                    firstValue = false
                } else {
                    graphPath.addLineToPoint(point)
                }
            } else {
                firstValue = true
            }
        }
        graphPath.stroke()
    }
}
