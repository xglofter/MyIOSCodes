//
//  ZHDMainViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMainViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZHDVCWithMenu.h"
#import "ZHDMainViewModel.h"
#import "APIClient.h"
#import "ZHDMainView.h"

@interface ZHDMainViewController () <ZHDMainViewDelegate> {
    ZHDMainView *_mainView;
}


@end


@implementation ZHDMainViewController

- (void)loadView {
    _mainView = [[ZHDMainView alloc] init];
    _mainView.delegate = self;
    self.view = _mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(onMenuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];

    @weakify(self);
    [self.viewModel.updateTableSignal subscribeNext:^(id x) {
        @strongify(self);
        [self->_mainView.tableView reloadData];
    }];

}

- (void)onMenuAction {
    NSLog(@"onMenuAction");

    [self.parentVC openMenuView]; // open the Menu
}

#pragma mark ZHDMainViewDelegate

- (void)mainViewTableViewSelected:(NSIndexPath *)indexPath {
    NSLog(@"mainViewTableView Selected");
}

- (NSInteger)mainViewTableViewNumberOfSections {
    return [self.viewModel numberOfSections];
}

- (NSInteger)mainViewTableViewNumberOfRows:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (NSString *)mainViewTableViewContentTitle:(NSIndexPath *)indexPath {
    return [self.viewModel titleAtIndexPath:indexPath];
}

- (NSString *)mainViewTableViewHeaderTitle:(NSInteger)section {
    return [self.viewModel titleForSection:section];
}


@end




