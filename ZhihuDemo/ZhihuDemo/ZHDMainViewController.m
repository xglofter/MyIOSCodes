//
//  ZHDMainViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMainViewController.h"

#import "ZHDVCWithMenu.h"

#import "ZHDMainViewModel.h"

@interface ZHDMainViewController ()

@property(nonatomic, strong) ZHDMainViewModel *viewModel;

@end


@implementation ZHDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(onMenuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];

}

- (void)onMenuAction {
    NSLog(@"onMenuAction");

    [self.parentVC openMenuView]; // open the Menu
}

@end
