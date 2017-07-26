//
//  Square.swift
//  AJMAnimatorView
//
//  Created by Angel Jesse Morales Karam Kairuz on 25/07/17.
//  Copyright © 2017 TheKairuzBlog. All rights reserved.
//

import UIKit

struct Square : Animatable {
    
    var path: UIBezierPath
    var animatedMask: CAShapeLayer
    
    // MARK: - Initializer
    
    init(rect : CGRect) {
        path = Square.createRectanglePathsUsing(rect)
        animatedMask = Square.createAnimatedMaskOnUsing(path.cgPath, onRect: rect)
    }
    
    // MARK: - Helper functions
    
    fileprivate static func createRectanglePathsUsing(_ rect : CGRect, resultPath: UIBezierPath = UIBezierPath()) -> UIBezierPath {
        
        let minimumAcceptableValue = CGFloat(0.01)
        if rect.width <= minimumAcceptableValue  || rect.height <= minimumAcceptableValue {
            return resultPath
        }
        
        let newPath = createRectanglePathFrom(rect)
        resultPath.append(newPath)
        
        // shrink current rect
        let pct = CGFloat(0.10)
        let newRect = rect.insetBy(dx: rect.width * (pct/2), dy: rect.height * (pct/2))
        
        return createRectanglePathsUsing(newRect, resultPath: resultPath)
    }
    
    fileprivate static func createRectanglePathFrom(_ rect : CGRect) -> UIBezierPath {
        let origin = rect.origin
        
        let left = CGPoint(x: rect.minX, y: rect.maxY)
        let right = CGPoint(x: rect.maxX, y: rect.maxY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: left)
        path.move(to: left)
        path.addLine(to: right)
        path.move(to: right)
        path.addLine(to: topRight)
        path.move(to: topRight)
        path.addLine(to: origin)
        
        return path
    }
    
    fileprivate static func createAnimatedMaskOnUsing(_ path : CGPath, onRect rect : CGRect) -> CAShapeLayer {
        let animationMaskLayer = CAShapeLayer()
        animationMaskLayer.frame = rect
        animationMaskLayer.fillColor = UIColor.red.cgColor
        animationMaskLayer.lineWidth = 95
        animationMaskLayer.strokeStart = 0.0
        animationMaskLayer.strokeEnd = 1.0
        animationMaskLayer.strokeColor = UIColor.red.cgColor
        animationMaskLayer.path = path
        return animationMaskLayer
    }
    
    // MARK: - Animatable protocol functions
    
    func animate(layer : CALayer) {
        let animations = CAAnimationGroup()
        var animationsArray = Array<CAAnimation>()
        
        let nextAnimation = CABasicAnimation(keyPath: "strokeEnd")
        nextAnimation.duration = 7
        nextAnimation.beginTime = 0
        nextAnimation.fromValue = 0
        nextAnimation.toValue = 1
        nextAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        nextAnimation.fillMode = kCAFillModeForwards
        animationsArray.append(nextAnimation)
        
        animations.animations = animationsArray
        animations.repeatCount = HUGE
        animations.duration = 7
        
        animatedMask.add(animations, forKey: "rightAnimation")
        layer.mask = animatedMask
    }
    
   
    
    
}
