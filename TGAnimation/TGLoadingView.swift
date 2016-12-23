//
//  TGLoadingView.swift
//
//  Created by Richard on 16/9/13.
//

import UIKit

func dispatch_async_to_main_safely(block: ()->()) {
    if NSThread.isMainThread() {
        block()
    } else {
        dispatch_async(dispatch_get_main_queue()) {
            block()
        }
    }
}

class TGLoadingView: UIImageView {
    
    var rotationAnimation: CABasicAnimation!
    private let AnimationKey = "transform.rotation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.image = UIImage(named: "ic_loading")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startRotateAnimation() {
        
        if self.rotationAnimation != nil { return }
        
        dispatch_async_to_main_safely {
            let rotationAnimation = CABasicAnimation(keyPath: self.AnimationKey)
            rotationAnimation.fromValue = NSNumber(double: 0)
            rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
            rotationAnimation.duration = 0.8
            rotationAnimation.cumulative = true
            rotationAnimation.repeatCount = MAXFLOAT
            self.rotationAnimation = rotationAnimation
            
            self.layer.addAnimation(self.rotationAnimation, forKey: self.AnimationKey)
        }
    }
    
    func stopRotateAnimation() {
        dispatch_async_to_main_safely {
            self.rotationAnimation = nil
            self.layer.removeAnimationForKey(self.AnimationKey)
        }
    }
    
}