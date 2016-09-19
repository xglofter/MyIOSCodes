//
//  TGCCyclePercentView2.swift
//  TGCToastViewDemo
//
//  Created by Richard on 16/9/10.
//  Copyright © 2016年 guang xu. All rights reserved.
//

import UIKit

private let TGCycleMinAngle: CGFloat = CGFloat(-M_PI-M_PI_4)
private let TGCycleMaxAngle: CGFloat = CGFloat(M_PI_4)
private let TGCycleRadiusPer: Float = 0.9
private let TGCycleBgLineWidthPer: Float = 0.15
private let TGCycleLineWidthPer: Float = 0.1
private let TGCycleBgColor: UIColor = UIColor.grayColor().colorWithAlphaComponent(0.4)

class TGCyclePercentView2: UIView {

    // from 0 to 1
    var progress: Float = 0.0 {
        didSet {
            if progress > 1 { progress = 1 }
            if progress < 0 { progress = 0 }
            colorMaskLayer.strokeEnd = CGFloat(progress)
        }
    }

    private(set) var maxWidth: CGFloat!
    private(set) var radius: CGFloat!
    private(set) var bgLineWidth: CGFloat!
    private(set) var lineWidth: CGFloat!

    private var colorLayer: CAShapeLayer!     // 渐变色layer
    private var colorMaskLayer: CAShapeLayer! // 渐变色layer的遮罩
    private var maskLayer: CAShapeLayer!      // 整个layer的遮罩

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = TGCycleBgColor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.backgroundColor = TGCycleBgColor

        let boundWid = self.bounds.width
        let boundHei = self.bounds.height
        maxWidth = ((boundWid < boundHei) ? boundWid : boundHei)
        radius = maxWidth * 0.5 * CGFloat(TGCycleRadiusPer)
        bgLineWidth = maxWidth * 0.5 * CGFloat(TGCycleBgLineWidthPer)
        lineWidth = maxWidth * 0.5 * CGFloat(TGCycleLineWidthPer)

        setupColorLayer()
        setupColorMaskLayer()
        setupMaskLayer()
    }

    private func setupColorLayer() {

        colorLayer = CAShapeLayer()
        colorLayer.contentsScale = UIScreen.mainScreen().scale
        colorLayer.frame = self.bounds
        self.layer.addSublayer(colorLayer)

        let leftLayer = CAGradientLayer()
        leftLayer.frame = CGRectMake(0, 0, frame.width/2, frame.height)
        leftLayer.locations = [0.2, 0.8, 1]
        leftLayer.colors = [UIColor.yellowColor().CGColor, UIColor.greenColor().CGColor]
        colorLayer.addSublayer(leftLayer)

        let rightLayer = CAGradientLayer()
        rightLayer.frame = CGRectMake(frame.width/2, 0, frame.width/2, frame.height)
        rightLayer.locations = [0.2, 0.8, 1]
        rightLayer.colors = [UIColor.yellowColor().CGColor, UIColor.redColor().CGColor]
        colorLayer.addSublayer(rightLayer)
    }

    private func setupColorMaskLayer() {
        colorMaskLayer = generateMaskLayer(self.bounds)
        colorMaskLayer.lineWidth = self.lineWidth
        colorLayer.mask = colorMaskLayer
    }

    private func setupMaskLayer() {
        maskLayer = generateMaskLayer(self.bounds)
        maskLayer.lineWidth = self.bgLineWidth
        self.layer.mask = maskLayer
    }

    private func generateMaskLayer(theRect: CGRect) -> CAShapeLayer {

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = theRect
        let center = CGPointMake(frame.width * 0.5, frame.height * 0.5)
        let radius = self.radius
        let startAngle = TGCycleMinAngle
        let endAngle = TGCycleMaxAngle
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = bezierPath.CGPath
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.whiteColor().CGColor // 其他颜色也可以
        shapeLayer.lineCap = kCALineCapRound

        return shapeLayer
    }
}
