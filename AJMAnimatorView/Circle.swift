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
    var animatedMask: CAShapeLayer
    
    private var segments :  Array<CGFloat>
    var totalAnimationDuration: Double = 10

    // MARK: - Initializer
    
    init(rect : CGRect) {
        
        let maxSize = rect.width > rect.height ? rect.width : rect.height
    
        var square = CGRect(x: 0, y:  0, width: maxSize, height: maxSize)
        square = square.offsetBy(dx: (-1 * (rect.width/5)), dy:0)
        let tuple  = Circle.createCirclePathsAndSegmentsUsing(square)
        
        path = Circle.unifyCirclePaths(tuple.0)
        segments = tuple.1
        
        animatedMask = Circle.createAnimatedMaskOn(rect: square, using:path)
    }
    
     // MARK: - Helper functions
    
    fileprivate static func unifyCirclePaths(_ paths : [UIBezierPath]) -> UIBezierPath {
        let result = UIBezierPath()
        for temp in (0..<paths.count) {
            result.append(paths[temp])
        }
        return result
    }
    
    fileprivate static func createAnimatedMaskOn(rect : CGRect, using path : UIBezierPath) -> CAShapeLayer {
        let animationMaskLayer = CAShapeLayer()
        animationMaskLayer.frame = rect
        animationMaskLayer.fillColor = UIColor.clear.cgColor
        animationMaskLayer.lineWidth = 40
        animationMaskLayer.strokeStart = 0.0
        animationMaskLayer.strokeEnd = 1.0
        animationMaskLayer.strokeColor = UIColor.red.cgColor
        animationMaskLayer.path = path.cgPath
        return animationMaskLayer
    }
    
    fileprivate static func createCirclePathsAndSegmentsUsing(_ rect : CGRect, path : [UIBezierPath] = [], segments : Array<CGFloat> = []) -> ([UIBezierPath], Array<CGFloat>)  {
        
        let minimumAcceptableValue = CGFloat(0.1)
        if rect.width <= minimumAcceptableValue || rect.height <= minimumAcceptableValue {
            return (path, segments)
        }
     
        // create and append a segment
        var mutableSegments = segments
        let aSegment = CGFloat(2 * rect.width) * CGFloat(M_PI)
        mutableSegments.append(aSegment)
        
        // create a path
        let middlePoint = CGPoint(x: rect.midX, y: rect.midY)
        let bottomPath = UIBezierPath(arcCenter: middlePoint, radius: rect.width / 2, startAngle: 0, endAngle: CGFloat(M_PI), clockwise: true)
        let upperPath = UIBezierPath(arcCenter: middlePoint, radius: rect.width / 2, startAngle: CGFloat(M_PI), endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        let singlePath = UIBezierPath()
        singlePath.append(bottomPath)
        singlePath.append(upperPath)
        
        var paths = path
        paths.append(singlePath)
        
        // decrease the size of current rect
        let kDiminishFactor = CGFloat(0.04) / 2
        let newRect = rect.insetBy(dx: rect.width * kDiminishFactor, dy: rect.height * kDiminishFactor)
        
        return createCirclePathsAndSegmentsUsing(newRect, path: paths, segments: mutableSegments)
    }
    
    // MARK: - Animatable protocol functions
    
    func animate(layer: CALayer) {
        
        func createAnimationGroup() -> CAAnimationGroup {
            
            var totalSegmentLength: CGFloat = 0.0
            
            for segment in segments {
                totalSegmentLength += segment
            }
            
            let animations = CAAnimationGroup()
            var animationsArray = Array<CAAnimation>()
            
            var lastAnimationEndTime: Double = 0.0
            var lastStrokeEnd: CGFloat = 0.0
            
            for line in 0..<segments.count {
                let segment = segments[line]
                let portion = segment / totalSegmentLength
                
                let nextAnimation = CABasicAnimation(keyPath: "strokeEnd")
                nextAnimation.duration = Double(portion) * self.totalAnimationDuration

                nextAnimation.beginTime = lastAnimationEndTime
                nextAnimation.fromValue = lastStrokeEnd
                nextAnimation.toValue = lastStrokeEnd + portion
                nextAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                nextAnimation.fillMode = kCAFillModeForwards
                
                lastStrokeEnd += portion
                lastAnimationEndTime += Double(portion) * self.totalAnimationDuration
                
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


