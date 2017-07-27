//
//  AJMAnimatorView.swift
//  AJMAnimatorView
//
//  Created by TheKairuz on 13/05/17.
//  Copyright © 2017 TheKairuzBlog. All rights reserved.
//

import UIKit

enum AJMAnimatorStyle {
    case Circle
    case Square
}

class AJMAnimatorView : UIView {
    
    private var imageView : UIImageView?
    private var animator : Animatable?
    
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
    }
    
    func animateImage(image : UIImage, usingStyle style : AJMAnimatorStyle = .Square) {
        imageView = UIImageView(image: image)
        imageView?.contentMode = .scaleAspectFit
        imageView?.frame = self.bounds
        self.addSubview(imageView!)
        
        switch style {
        case .Circle:
            animator = Circle(rect: self.bounds)
        default:
            animator = Square(rect: self.bounds)
        }
        
        animator?.animate(layer: self.layer)
    }
    
    
}
