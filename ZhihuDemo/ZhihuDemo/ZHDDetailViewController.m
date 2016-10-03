//
//  ZHDDetailViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/8.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZHDDetailView.h"
#import "ZHDDetailViewModel.h"

@interface ZHDDetailViewController () {
    ZHDDetailView *_detailView;
}

@property(nonatomic, strong) NSNumber* newsId;

@end

@implementation ZHDDetailViewController

- (instancetype)initWithNewsId: (NSNumber *)nid {
    if (self = [super init]) {
        self.newsId = nid;
    }
    return self;
}

- (void)loadView {
    _detailView = [[ZHDDetailView alloc] init];
//    _detailView.delegate = self;
    self.view = _detailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.viewModel = [[ZHDDetailViewModel alloc] initWithModel:self.newsId];

    @weakify(self);
    [self.viewModel.updateTableSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        [self->_detailView loadHTMLString:x];
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    self.viewModel.active = YES;
}

- (void)onBackAction {
    if (_detailView.webView.canGoBack) {
        [_detailView.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [_detailView backPage];
}

@end
