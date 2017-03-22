//
//  UIApplication+Helper.swift
//  TestSwift
//
//  Created by Richard on 2017/3/21.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit


extension UIApplication {
    
    /// 返回最顶层UIViewController实例
    ///
    /// - Returns: UIViewController?
    class func topMostViewController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
