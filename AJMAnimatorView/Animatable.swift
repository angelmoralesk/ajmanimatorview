//
//  Animatable.swift
//  AJMAnimatorView
//
//  Created by Angel Jesse Morales Karam Kairuz on 24/07/17.
//  Copyright © 2017 TheKairuzBlog. All rights reserved.
//

import UIKit

protocol Animatable {
    func animate(layer : CALayer)
}

struct CrossDisolver : Animatable {
    
    var path: UIBezierPath
    var mask: CAShapeLayer
    
    init(rect : CGRect) {
        path = CrossDisolver.createPathByShrinkingRect(rect: rect, path: UIBezierPath(), counter: 0)
        mask = CrossDisolver.createAnimatedMaskOn(rect : rect, path: path)
    }
    
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
        
        mask.add(animations, forKey: "rightAnimation")
        layer.mask = mask
    }
    
    fileprivate static func createPathByShrinkingRect(rect : CGRect, path: UIBezierPath, counter : Int) -> UIBezierPath {
        print(rect)
        if counter == 100 {
            return path
        }
        let newPath = retrievePathFrom(rect: rect)
        path.append(newPath)
        
        let pct = CGFloat(0.10)
        let newRect = rect.insetBy(dx: rect.width * (pct/2), dy: rect.height * (pct/2))
        
        return createPathByShrinkingRect(rect: newRect, path: path, counter: counter + 1)
    }
    
    fileprivate static func retrievePathFrom(rect : CGRect) -> UIBezierPath {
        
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
    
    fileprivate static func createAnimatedMaskOn(rect : CGRect, path : UIBezierPath) -> CAShapeLayer {
        let animationMaskLayer = CAShapeLayer()
        animationMaskLayer.frame = rect
        animationMaskLayer.fillColor = UIColor.red.cgColor
        animationMaskLayer.lineWidth = 95
        animationMaskLayer.strokeStart = 0.0
        animationMaskLayer.strokeEnd = 1.0
        animationMaskLayer.strokeColor = UIColor.red.cgColor
        animationMaskLayer.path = path.cgPath
        return animationMaskLayer
    }
    
    
}
