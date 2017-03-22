//
//  UIColor+Helper.swift
//  TestSwift
//
//  Created by Richard on 2017/3/21.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit

// MARK: - UIColor with hex support

public extension UIColor {
    
    /// 十六进制代码颜色表示法初始化
    ///
    /// - Parameter hex: 如：白色 "#FFFFFF"
    convenience init(hex: String) {
        
        let noHasString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHasString)
        scanner.charactersToBeSkipped = CharacterSet.symbols
        
        var hexInt: UInt32 = 0
        if (scanner.scanHexInt32(&hexInt)) {
            let red = CGFloat((hexInt >> 16) & 0xFF)
            let green = CGFloat((hexInt >> 8) & 0xFF)
            let blue = CGFloat((hexInt) & 0xFF)
            
            self.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}
