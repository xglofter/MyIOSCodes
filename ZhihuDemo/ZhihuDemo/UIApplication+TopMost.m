//
//  NSObject+UIApplication_TopMost.m
//  ZhihuDemo
//
//  Created by Richard on 16/10/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UIApplication+TopMost.h"


@implementation NSObject (UIApplication_TopMost)

/**
 *  @brief return top most UIViewContoller
 */
+ (UIViewController *)topMostController {

    UIViewController * tempTopVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (tempTopVC.presentedViewController != nil) {
        tempTopVC = tempTopVC.presentedViewController;
    }
    return tempTopVC;
}

@end
