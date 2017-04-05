//
//  FixOrientation.swift
//  TogicHelper
//
//  Created by guang xu on 16/4/11.
//  Copyright © 2016年 Richard. All rights reserved.
//

import UIKit

func fixOrientation(_ aImage: UIImage) -> UIImage {
    
    if (aImage.imageOrientation == .up) {
        return aImage
    }
    
    var transform = CGAffineTransform.identity
    
    switch (aImage.imageOrientation) {
    case .down, .downMirrored:
        transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
        transform = transform.rotated(by: CGFloat(M_PI))
    case .left, .leftMirrored:
        transform = transform.translatedBy(x: aImage.size.width, y: 0)
        transform = transform.rotated(by: CGFloat(M_PI_2))
    case .right, .rightMirrored:
        transform = transform.translatedBy(x: 0, y: aImage.size.height)
        transform = transform.rotated(by: CGFloat(-M_PI_2))
    default:
        break
    }
    
    switch (aImage.imageOrientation) {
    case .upMirrored, .downMirrored:
        transform = transform.translatedBy(x: aImage.size.width, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    case .leftMirrored, .rightMirrored:
        transform = transform.translatedBy(x: aImage.size.height, y: 0)
        transform = transform.scaledBy(x: -1, y: 1)
    default:
        break
    }
    
    let ctx = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height),
        bitsPerComponent: aImage.cgImage!.bitsPerComponent, bytesPerRow: 0,
        space: aImage.cgImage!.colorSpace!,
        bitmapInfo: CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue).rawValue
    )
    
    ctx!.concatenate(transform)
    
    switch (aImage.imageOrientation) {
    case .left, .leftMirrored, .right, .rightMirrored:
        ctx!.draw(aImage.cgImage!, in: CGRect(x: 0,y: 0,width: aImage.size.height,height: aImage.size.width))
    default:
        ctx!.draw(aImage.cgImage!, in: CGRect(x: 0,y: 0,width: aImage.size.width,height: aImage.size.height))
    }
    
    // And now we just create a new UIImage from the drawing context
    let cgimg = ctx!.makeImage()
    return UIImage(cgImage: cgimg!)
}

