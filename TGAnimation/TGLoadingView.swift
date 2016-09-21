//
//  TGLoadingView.swift
//
//  Created by Richard on 16/9/13.
//

import UIKit

private let TGAnimationKey = "transform.rotation"

class TGLoadingView: UIImageView {

    var rotationAnimation: CABasicAnimation!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.image = UIImage(named: "loading")

        let rotationAnimation = CABasicAnimation(keyPath: TGAnimationKey)
        rotationAnimation.fromValue = NSNumber(double: 0)
        rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
        rotationAnimation.duration = 0.8
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        self.rotationAnimation = rotationAnimation
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimation() {
        self.layer.addAnimation(self.rotationAnimation, forKey: TGAnimationKey)
    }

    func stopAnimation() {
        self.layer.removeAnimationForKey(TGAnimationKey)
    }
    
}
