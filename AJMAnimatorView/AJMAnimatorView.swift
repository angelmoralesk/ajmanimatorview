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
    
        
    }
    
    
}
