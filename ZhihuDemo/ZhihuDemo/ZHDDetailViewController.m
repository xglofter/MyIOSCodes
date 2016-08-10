//
//  ZHDDetailViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/8.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDDetailViewController.h"

#import "ZHDDetailView.h"

@interface ZHDDetailViewController () {
    ZHDDetailView *_detailView;
}

@end

@implementation ZHDDetailViewController

- (void)loadView {
    _detailView = [[ZHDDetailView alloc] init];
//    _detailView.delegate = self;
    self.view = _detailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
