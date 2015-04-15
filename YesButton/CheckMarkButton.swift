//
//  CheckMarkButton.swift
//  CheckMarkButton
//
//  Created by apple on 15-4-14.
//  Copyright (c) 2015年 apple.com. All rights reserved.
//

/*
 *  动画主要有三个Layer构成，其中grayCircleLayer是暗红色、静止的
 *  checkMarkLayer 是打钩动画
 *  circleLayer 是转圈动画
 */

import CoreGraphics
import QuartzCore
import UIKit

public class CheckMarkButton: UIButton {
    
    private let width: CGFloat = 50
    private let height: CGFloat = 50
    private let radius: CGFloat = 25
    private let lineWidth: CGFloat = 4
    
    private let circleLayer = CAShapeLayer()
    private let checkMarkLayer = CAShapeLayer()
    private let grayCircleLayer = CAShapeLayer()
    
    private let animationDuration = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit( ){
        
        var x:CGFloat = 0.0
        var y:CGFloat = 0.0
        
        var checkmarkPath = UIBezierPath()
        
        x = radius - radius * sin(0.25 * CGFloat(M_PI))
        y = x
        let startPoint = CGPointMake(x, y)
        checkmarkPath.moveToPoint(startPoint)
        
        x = radius
        y = radius*1.2
        let midPoint = CGPointMake(x, y)
        checkmarkPath.addLineToPoint(midPoint)
        
        x = radius + radius * sin(0.25 * CGFloat(M_PI))
        y = radius - radius * sin(0.25 * CGFloat(M_PI))
        let endPoint = CGPointMake(x, y)
        checkmarkPath.addLineToPoint(endPoint)
        
        checkMarkLayer.path = checkmarkPath.CGPath
        checkMarkLayer.lineWidth = lineWidth
        checkMarkLayer.lineCap = kCALineCapRound
        checkMarkLayer.lineJoin = kCALineJoinRound
        checkMarkLayer.fillColor = UIColor.clearColor().CGColor
        checkMarkLayer.strokeColor = UIColor.redColor().CGColor
        checkMarkLayer.strokeEnd = 0.0
        checkMarkLayer.strokeStart = 0.0
        layer.addSublayer(checkMarkLayer)
        
        var circlePath = UIBezierPath()
        circlePath.addArcWithCenter(CGPointMake(width/2, height/2), radius: radius, startAngle: 1.25*CGFloat(M_PI), endAngle: 3.25*CGFloat(M_PI), clockwise: false)

        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.redColor().CGColor
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = lineWidth
        
        layer.addSublayer(circleLayer)
        
        
        grayCircleLayer.path = circlePath.CGPath
        grayCircleLayer.fillColor = UIColor.clearColor().CGColor
        grayCircleLayer.strokeColor = UIColor.redColor().CGColor
        grayCircleLayer.opacity = 0.4
        grayCircleLayer.lineWidth = lineWidth
        layer.addSublayer(grayCircleLayer)

    }
    
    override public func intrinsicContentSize() -> CGSize {
        return CGSize(width: width, height: height)
    }
    
    public var showAnimation: Bool = false {
        didSet {
            var circleStrokeStart = CABasicAnimation(keyPath: "strokeStart")
            circleStrokeStart.duration = 0.8 * animationDuration
            circleStrokeStart.beginTime = 0.0
            
            /*
             * 因为是kCALineCapRound，所以toValue需设为1.1，否则会有一个小红点
             */
            
            circleStrokeStart.fromValue = showAnimation ? NSNumber(float: 0.0) : NSNumber(float: 1.1)
            circleStrokeStart.toValue   = showAnimation ? NSNumber(float: 1.1) : NSNumber(float: 0.0)
            circleStrokeStart.removedOnCompletion = false
            circleStrokeStart.fillMode = kCAFillModeForwards
            
            var checkMarkAnimationGroup = CAAnimationGroup()
            checkMarkAnimationGroup.removedOnCompletion = false
            checkMarkAnimationGroup.fillMode = kCAFillModeForwards
            checkMarkAnimationGroup.duration = animationDuration
            checkMarkAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            circleLayer.addAnimation(circleStrokeStart, forKey: "checkLayerAnimation")
            
            var markStrokeEnd = CAKeyframeAnimation(keyPath: "strokeEnd")
            markStrokeEnd.duration = 0.8 * animationDuration
            markStrokeEnd.removedOnCompletion = false
            markStrokeEnd.fillMode = kCAFillModeForwards
            markStrokeEnd.calculationMode = kCAAnimationPaced
            markStrokeEnd.values = showAnimation ? [0.0,0.85] : [0.85,0.0]
            
            var markStrokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
            markStrokeStart.duration = 0.3 * animationDuration
            markStrokeStart.removedOnCompletion = false
            markStrokeStart.fillMode = kCAFillModeForwards
            markStrokeStart.values = showAnimation ? [0.0,0.3] : [0.3,0.0]
            if showAnimation {
                markStrokeStart.beginTime = 0.6 * animationDuration
            }
            
            checkMarkAnimationGroup.animations = [markStrokeEnd,markStrokeStart]
            
            checkMarkLayer.addAnimation(checkMarkAnimationGroup, forKey: "checkMarkAnimation")
        }
    }
}