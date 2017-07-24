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
    
    
}
