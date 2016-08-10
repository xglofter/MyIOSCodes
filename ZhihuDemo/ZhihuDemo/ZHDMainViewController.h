//
//  ZHDMainViewController.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHDMainViewModel;
@class ZHDVCWithMenu;

@interface ZHDMainViewController : UIViewController

@property(nonatomic, weak) ZHDVCWithMenu *parentVC;

@property(nonatomic, strong) ZHDMainViewModel *viewModel;


@end
