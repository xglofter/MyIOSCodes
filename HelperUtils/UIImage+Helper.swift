//
//  Image+Helper.swift
//  TestSwift
//
//  Created by Richard on 2017/3/21.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /// 使用纯色初始化UIImage
    ///
    /// - Parameter color: 所使用的颜色
    /// - Parameter size: 设置大小
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 2, height: 2)) {
        
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        self.init(cgImage: (UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    /// 使用渐变色初始化UIImage
    ///
    /// - Parameter gradientColors: 所使用的颜色数组
    /// - Parameter size: 设置大小
    /// - Parameter locations: 渐变位置数组
    convenience init?(gradientColors:[UIColor], size:CGSize = CGSize(width: 2, height: 2), locations: [Float] = [] )
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map {(color: UIColor) -> AnyObject! in return color.cgColor as AnyObject! } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }


    /// 使用水印文字
    ///
    /// - Parameter text: 文字
    /// - Returns: 生成的水印文字图片
    func drawTextInImage(text: String) -> UIImage {
        //开启图片上下文
        UIGraphicsBeginImageContext(self.size)
        //图形重绘
        self.draw(in: CGRect(x: 0,y: 0, width: self.size.width, height: self.size.height))
        //水印文字属性
        let att = [
            NSForegroundColorAttributeName:UIColor.white,
            NSFontAttributeName:UIFont.systemFont(ofSize: 16),
            NSBackgroundColorAttributeName:UIColor.clear
        ]
        //水印文字大小
        let text = NSString(string: text)
        let size = text.size(attributes: att)
        //绘制文字
        text.draw(in: CGRect(x: 5, y: 5, width: size.width, height: size.height), withAttributes: att)
        //从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image
    }
}
