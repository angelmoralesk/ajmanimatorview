//
//  Circular.swift
//  AJMAnimatorView
//
//  Created by Angel Jesse Morales Karam Kairuz on 25/07/17.
//  Copyright © 2017 TheKairuzBlog. All rights reserved.
//

import UIKit

struct Circle : Animatable {
    
    var path: UIBezierPath
    var animatedMasks: CAShapeLayer
    
    // MARK: - Initializer
    
    init(rect : CGRect) {
        path = Circle.createAnimatedMasksShrinkingCircle(rect, path: UIBezierPath())
        animatedMasks = Circle.createAnimatedMaskOn(rect: rect, path: path)
    }
    
     // MARK: - Helper functions
    
    fileprivate static func createAnimatedMaskOn(rect : CGRect, path : UIBezierPath) -> CAShapeLayer {
        let animationMaskLayer = CAShapeLayer()
        animationMaskLayer.frame = rect
        animationMaskLayer.fillColor = UIColor.red.cgColor
        animationMaskLayer.lineWidth = 10
        animationMaskLayer.strokeStart = 0.0
        animationMaskLayer.strokeEnd = 1.0
        animationMaskLayer.strokeColor = UIColor.red.cgColor
        animationMaskLayer.path = path.cgPath
        return animationMaskLayer
    }
    
    fileprivate static func createAnimatedMasksShrinkingCircle(_ rect : CGRect, path : UIBezierPath) -> UIBezierPath {
        print(rect)
        
        if rect.width <= 50 || rect.height <= 50 {
            return path
        }
        var resultPath = path
        let middlePoint = CGPoint(x: rect.midX, y: rect.midY)
        
        let bottomPart = UIBezierPath(arcCenter: middlePoint, radius: rect.width / 2, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        let upperPart = UIBezierPath(arcCenter: middlePoint, radius: rect.width / 2, startAngle: CGFloat(M_PI), endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        resultPath.append(bottomPart)
        resultPath.append(upperPart)
        
        let pct = CGFloat(0.05)
        let newRect = rect.insetBy(dx: rect.width * (pct/2), dy: rect.height * (pct/2))
        
        return createAnimatedMasksShrinkingCircle(newRect, path: resultPath)
    }
    
    // MARK: - Animatable protocol functions
    
    func animate(layer: CALayer) {
        
        func createAnimationGroup() -> CAAnimationGroup {
            
            var totalPathLength: CGFloat = 0.0
            
            for lineSegment in segments {
                totalPathLength += lineSegment
            }
            
            let animations = CAAnimationGroup()
            var animationsArray = Array<CAAnimation>()
            
            var lastAnimationEndTime: Double = 0.0
            var lastStrokeEnd: CGFloat = 0.0
            
            for line in 0..<segments.count {
                let segmentLength = segments[line]
                let portion = segmentLength / totalPathLength
                
                let nextAnimation = CABasicAnimation(keyPath: "strokeEnd")
                nextAnimation.duration = Double(portion) * (self.totalAnimationDuration / 2)

                nextAnimation.beginTime = lastAnimationEndTime
                nextAnimation.fromValue = lastStrokeEnd
                nextAnimation.toValue = lastStrokeEnd + portion
                nextAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                nextAnimation.fillMode = kCAFillModeForwards
                
                lastStrokeEnd += portion
                lastAnimationEndTime += Double(portion) * (self.totalAnimationDuration / 2)
                
                animationsArray.append(nextAnimation)
            }
            
             animations.animations = animationsArray
             animations.repeatCount = HUGE
             animations.duration = self.totalAnimationDuration
            return animations
        }
       
        let animation = createAnimationGroup()
        animatedMask.add(animation, forKey: "rightAnimation")
        
        layer.mask = animatedMask
        
    }
    
    
}


