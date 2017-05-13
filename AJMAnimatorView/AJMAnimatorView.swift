//
//  AJMAnimatorView.swift
//  AJMAnimatorView
//
//  Created by TheKairuz on 13/05/17.
//  Copyright © 2017 TheKairuzBlog. All rights reserved.
//

import UIKit

class AJMAnimatorView : UIView {
    
    private var imageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepareImageView() {
        guard imageView != nil else {
            imageView = UIImageView(frame: self.bounds)
            self.addSubview(imageView!)
            return
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       // prepareImageView()
    }
    
    func animateImage(image : UIImage) {
        imageView = UIImageView(image: image)
        imageView?.contentMode = .scaleAspectFit
        imageView?.frame = self.bounds
        self.addSubview(imageView!)
        let path = retrievePathByShrinkingRect(rect: self.bounds, path: UIBezierPath(), counter: 0)
        let mask = createAnimatedMaskOn(path: path)
        performAnimations(animationMaskLayer: mask , path: path)
    }
    
    func performAnimations(animationMaskLayer : CAShapeLayer, path : UIBezierPath) {
        
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
        //animations.delegate =
        
        animationMaskLayer.add(animations, forKey: "rightAnimation")
        
        self.layer.mask = animationMaskLayer

    }
    
    func createAnimatedMaskOn(path : UIBezierPath) -> CAShapeLayer {
        let animationMaskLayer = CAShapeLayer()
        animationMaskLayer.frame = self.bounds
        animationMaskLayer.fillColor = UIColor.red.cgColor
        animationMaskLayer.lineWidth = 95
        animationMaskLayer.strokeStart = 0.0
        animationMaskLayer.strokeEnd = 1.0
        animationMaskLayer.strokeColor = UIColor.red.cgColor
        animationMaskLayer.path = path.cgPath
        return animationMaskLayer
    }
    
    func retrievePathFrom(rect : CGRect) -> UIBezierPath {
        
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
    
    func retrievePathByShrinkingRect(rect : CGRect, path: UIBezierPath, counter : Int) -> UIBezierPath {
        
        print(rect)
        if counter == 100 {
            return path
        }
        let newPath = retrievePathFrom(rect: rect)
        path.append(newPath)
        
        let pct = CGFloat(0.10)
        let newRect = rect.insetBy(dx: rect.width * (pct/2), dy: rect.height * (pct/2))
        
        return retrievePathByShrinkingRect(rect: newRect, path: path, counter: counter + 1)
    }
}
