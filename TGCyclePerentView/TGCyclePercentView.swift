//
//  TGCCyclePercentView.swift
//  TGCToastViewDemo
//
//  Created by Richard on 16/9/10.
//  Copyright © 2016年 guang xu. All rights reserved.
//

import UIKit

private let TGCycleMinAngle: CGFloat = CGFloat(-M_PI-M_PI_4)
private let TGCycleMaxAngle: CGFloat = CGFloat(M_PI_4)
private let TGCycleRadiusPer: Float = 0.9
private let TGCycleLineWidthPer: Float = 0.1
private let TGCycleColor: UIColor = UIColor.orangeColor()
private let TGCycleBgColor: UIColor = UIColor.grayColor().colorWithAlphaComponent(0.4)

class TGCyclePercentView: UIView {

    // from 0 to 1
    var progress: Float = 0.0 {
        didSet {
            if progress > 1 { progress = 1 }
            if progress < 0 { progress = 0 }
            self.setNeedsDisplay()
        }
    }

    lazy private(set) var maxWidth: CGFloat = { // width equal to height
        let boundWid = self.frame.size.width
        let boundHei = self.frame.size.height
        return ((boundWid < boundHei) ? boundWid : boundHei)
    }()

    lazy private(set) var radius: CGFloat = {
        return self.maxWidth * 0.5 * CGFloat(TGCycleRadiusPer)
    }()

    lazy private(set) var lineWidth: CGFloat = {
        return self.maxWidth * 0.5 * CGFloat(TGCycleLineWidthPer)
    }()

    override func drawRect(rect: CGRect) {

        let curContext = UIGraphicsGetCurrentContext()
        let center = CGPointMake(frame.width * 0.5, frame.height * 0.5)
        let startAngle = TGCycleMinAngle
        let endAngle = (TGCycleMaxAngle - TGCycleMinAngle) * CGFloat(progress) + startAngle

        let bezierBgPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: TGCycleMinAngle, endAngle: TGCycleMaxAngle, clockwise: true)
        CGContextSetLineWidth(curContext, lineWidth)
        CGContextSetLineCap(curContext, CGLineCap.Round)
        TGCycleBgColor.setStroke()
        CGContextAddPath(curContext, bezierBgPath.CGPath)
        CGContextStrokePath(curContext)

        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        CGContextSetLineWidth(curContext, lineWidth)
        CGContextSetLineCap(curContext, CGLineCap.Round)
        TGCycleColor.setStroke()
        CGContextAddPath(curContext, bezierPath.CGPath)
        CGContextStrokePath(curContext)
    }
}
