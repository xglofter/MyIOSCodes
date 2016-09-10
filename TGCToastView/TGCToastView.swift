//
//  ToastView.swift
//
//  Created by xglofter.
//  Copyright © 2016年 guang xu. All rights reserved.
//

import UIKit


let TGCToastHorizontalMargin: CGFloat = 12
let TGCToastVerticalMargin: CGFloat = 20
let TGCToastHorizontalMaxPer: CGFloat = 0.4  // 40% parent view width
let TGCToastVerticalMaxPer: CGFloat = 0.5    // 50% parent view height
let TGCToastImageWidth: CGFloat = 30
let TGCToastImageHeight: CGFloat = 30
let TGCToastSpaceBetweenTextAndImage: CGFloat = 14
let TGCToastErrorHeight: CGFloat = 25
let TGCToastErrorHorizontalMargin: CGFloat = 10
let TGCToastErrorVerticalMagin: CGFloat = 5

let TGCToastLayerCornerRadius: CGFloat = 12
let TGCToastLayerColor: UIColor = UIColor.blackColor()
let TGCToastLayerUseShadow: Bool = true
let TGCToastLayerShadowOpacity: CGFloat = 0.8
let TGCToastLayerShadowRadius: CGFloat = 5.0
let TGCToastLayerShadowOffset: CGSize = CGSizeMake(3.0, 3.0)
let TGCToastErrorLayerColor: UIColor = UIColor(red: 244/255, green: 81/255, blue: 78/255, alpha: 1)

let TGCToastTextColor: UIColor = UIColor.whiteColor()
let TGCToastErrorTextColor: UIColor = UIColor.whiteColor()

let TGCToastFadeInTime: Double = 0.5
let TGCToastFadeOutTime: Double = 0.4
let TGCToastDefaultTime: Double = 3
let TGCToastErrorMoveInTime: Double = 0.3
let TGCToastErrorMoveOutTime: Double = 0.2

var TGCTimer: UnsafePointer<NSTimer> = nil
var TGCToastView: UnsafePointer<UIView> = nil

var TGCErrorTimer: UnsafePointer<NSTimer> = nil
var TGCErrorToastView: UnsafePointer<UIView> = nil
var TGCErrorViewOriginBottomY: UnsafePointer<CGFloat> = nil

extension UIView {

    /**
     make a toast (only text)

     - parameter message:  message text
     - parameter duration: toast showing time(default is 3 seconds)
     */
    func tgc_makeToast(message: String, duration: Double = TGCToastDefaultTime) {
        tgc_toMakeToast(message, duration: duration, image: nil)
    }

    /**
     make a toast (image with text)

     - parameter message:  message text
     - parameter image: image
     - parameter duration: toast showing time(default is 3 seconds)
     */
    func tgc_makeToast(message: String, image: UIImage, duration: Double = TGCToastDefaultTime) {
        tgc_toMakeToast(message, duration: duration, image: image)
    }

    /**
     make a toast (only image)

     - parameter image: image
     - parameter duration: toast showing time(default is 3 seconds)
     */
    func tgc_makeToastImage(image: UIImage, duration: Double = TGCToastDefaultTime) {
        tgc_toMakeToast(nil, duration: duration, image: image)
    }

    /**
     make a error toast view

     - parameter message:  error information
     - parameter duration: showing time(default is 3 seconds)
     */
    func tgc_makeErrorToast(message: String, originBottomPosY posY: CGFloat = 0, duration: Double = TGCToastDefaultTime) {

        objc_setAssociatedObject(self, &TGCErrorViewOriginBottomY, posY, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        if let errorView = objc_getAssociatedObject(self, &TGCErrorToastView) {
            if let timer = objc_getAssociatedObject(errorView, &TGCErrorTimer) {
                timer.invalidate()
            }
            tgc_hideErrorView(errorView as! UIView, force: true)
        }

        let toast = tgc_errorView(message)
        self.addSubview(toast)
        objc_setAssociatedObject(self, &TGCErrorToastView, toast, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        tgc_showErrorView(toast, duration: duration)
    }

    private func tgc_toMakeToast(message: String?, duration: Double, image: UIImage?) {

        if let toastView = objc_getAssociatedObject(self, &TGCToastView) {
            if let timer = objc_getAssociatedObject(toastView, &TGCTimer) {
                timer.invalidate()
            }
            tgc_hideWrapperView(toastView as! UIView, force: true)
        }

        let toast = tgc_wrapperView(message, image: image)
        self.addSubview(toast)
        objc_setAssociatedObject(self, &TGCToastView, toast, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        tgc_showWrapperView(toast, duration: duration)
    }

    private func tgc_wrapperView(msg: String?, image: UIImage?) -> UIView {

        let wrapperView = UIView()
        wrapperView.layer.cornerRadius = TGCToastLayerCornerRadius
        wrapperView.backgroundColor = TGCToastLayerColor.colorWithAlphaComponent(0.9)
        wrapperView.alpha = 0.0
        if TGCToastLayerUseShadow {
            wrapperView.layer.shadowColor = TGCToastLayerColor.CGColor
            wrapperView.layer.shadowOpacity = Float(TGCToastLayerShadowOpacity)
            wrapperView.layer.shadowRadius = TGCToastLayerShadowRadius
            wrapperView.layer.shadowOffset = TGCToastLayerShadowOffset
        }

        var imageView: UIImageView!
        var msgLabel: UILabel!
        let parentSize = self.bounds.size

        if image != nil {
            imageView = UIImageView(image: image)
            imageView.contentMode = .ScaleAspectFill
            imageView.frame.size = CGSizeMake(TGCToastImageWidth, TGCToastImageHeight)
            wrapperView.addSubview(imageView)
        }

        if msg != nil {
            msgLabel = UILabel()
            msgLabel.text = msg
            msgLabel.textColor = TGCToastTextColor
            msgLabel.font = UIFont.systemFontOfSize(14)
            msgLabel.lineBreakMode = .ByWordWrapping
            msgLabel.numberOfLines = 0
            msgLabel.textAlignment = .Center
            wrapperView.addSubview(msgLabel)

            let maxMsgWidth = parentSize.width * TGCToastHorizontalMaxPer - TGCToastHorizontalMargin * 2
            let maxMsgHeight = tgc_heightForLabel(msgLabel, width: maxMsgWidth)
            msgLabel.frame.size = CGSizeMake(maxMsgWidth, maxMsgHeight)
        }

        let imageHeight = (imageView != nil) ? imageView.frame.size.height + ((msgLabel != nil) ? TGCToastSpaceBetweenTextAndImage : 0) : 0
        let textHeight = (msgLabel != nil) ? msgLabel.frame.size.height : 0
        let wrapperWidth = parentSize.width * TGCToastHorizontalMaxPer
        let wrapperHeight = min(imageHeight + textHeight + TGCToastVerticalMargin * 2, parentSize.height * TGCToastVerticalMaxPer)
        wrapperView.frame.size = CGSizeMake(wrapperWidth, wrapperHeight)
        wrapperView.center = CGPoint(x: parentSize.width * 0.5, y: parentSize.height * 0.5)

        if imageView != nil {
            imageView!.center = CGPointMake(wrapperWidth * 0.5, TGCToastVerticalMargin + imageView!.frame.size.height * 0.5)
        }

        if msgLabel != nil {
            msgLabel!.center = CGPointMake(wrapperWidth * 0.5, wrapperHeight - msgLabel!.frame.size.height * 0.5 - TGCToastVerticalMargin)
        }

        return wrapperView
    }

    private func tgc_errorView(message: String) -> UIView {

        let errorView = UIView()
        errorView.backgroundColor = TGCToastErrorLayerColor

        let textLabel = UILabel()
        textLabel.text = message
        textLabel.lineBreakMode = .ByWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.systemFontOfSize(14)
        textLabel.textColor = TGCToastErrorTextColor
        errorView.addSubview(textLabel)

        let parentSize = self.bounds.size
        let maxTextWidth = parentSize.width - TGCToastErrorHorizontalMargin * 2
        let maxTextHeight = tgc_heightForLabel(textLabel, width: maxTextWidth)
        textLabel.frame.size = CGSizeMake(maxTextWidth, maxTextHeight)
        errorView.frame.size = CGSizeMake(parentSize.width, maxTextHeight+TGCToastErrorVerticalMagin*2)
        textLabel.center = CGPointMake(errorView.frame.size.width * 0.5, errorView.frame.size.height * 0.5)

        let posY = objc_getAssociatedObject(self, &TGCErrorViewOriginBottomY) as! CGFloat
        errorView.center = CGPointMake(parentSize.width * 0.5, posY - errorView.frame.size.height * 0.5)

        return errorView
    }

    private func tgc_hideWrapperView(view: UIView, force: Bool) {
        func clearProperty() {
            view.removeFromSuperview()
            objc_setAssociatedObject(self, &TGCToastView, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            objc_setAssociatedObject(self, &TGCTimer, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if force {
            clearProperty()
        } else {
            UIView.animateWithDuration(TGCToastFadeOutTime, delay: 0.0, options: [.CurveEaseIn], animations: { view.alpha = 0.0 }) { (over: Bool) in
                clearProperty()
            }
        }
    }

    private func tgc_showWrapperView(view: UIView, duration: Double) {
        UIView.animateWithDuration(TGCToastFadeInTime, delay: 0, options: [.CurveEaseOut], animations: { view.alpha = 1.0 }) { (over: Bool) in
            let timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(self.tgc_onToHideToastView), userInfo: view, repeats: false)
            objc_setAssociatedObject(view, &TGCTimer, timer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private func tgc_hideErrorView(view: UIView, force: Bool) {
        func clearProperty() {
            view.removeFromSuperview()
            objc_setAssociatedObject(self, &TGCErrorToastView, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            objc_setAssociatedObject(self, &TGCErrorTimer, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        if force {
            clearProperty()
        } else {
            UIView.animateWithDuration(TGCToastErrorMoveOutTime, delay: 0.0, options: [.CurveEaseIn], animations: {
                let posY = objc_getAssociatedObject(self, &TGCErrorViewOriginBottomY) as! CGFloat
                view.frame.origin.y = posY - view.frame.size.height
            }) { (over: Bool) in
                clearProperty()
            }
        }
    }

    private func tgc_showErrorView(view: UIView, duration: Double) {
        UIView.animateWithDuration(TGCToastErrorMoveInTime, delay: 0, options: [.CurveEaseOut], animations: {
            view.frame.origin.y += view.frame.size.height
        }) { (over: Bool) in
            let timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(self.tgc_onToHideErrorToastView), userInfo: view, repeats: false)
            objc_setAssociatedObject(view, &TGCErrorTimer, timer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func tgc_onToHideToastView(timer: NSTimer) {
        self.tgc_hideWrapperView(timer.userInfo as! UIView, force: false)
    }

    func tgc_onToHideErrorToastView(timer: NSTimer) {
        self.tgc_hideErrorView(timer.userInfo as! UIView, force: false)
    }

    /**
     get a UILabel's max height, with UILabel's width

     - parameter textLabel: the text label
     - parameter width:     the text label's width

     - returns: get the label max height
     */
    func tgc_heightForLabel(textLabel: UILabel, width: CGFloat) -> CGFloat {
        let attributes = [NSFontAttributeName: textLabel.font!]
        let rect = (textLabel.text! as NSString).boundingRectWithSize(CGSizeMake(width, 0), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height
    }
}
