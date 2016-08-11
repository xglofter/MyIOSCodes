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

@interface ZHDMainViewController () <ZHDMainViewDelegate>

@property(nonatomic, strong) ZHDMainView *mainView;

@end


@implementation ZHDMainViewController

- (void)loadView {
    _mainView = [[ZHDMainView alloc] init];
    _mainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _mainView.delegate = self;
    self.view = _mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Main";
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuAction)];
    menuBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = menuBtn;

    @weakify(self);
    [self.viewModel.updateTableSignal subscribeNext:^(id x) {
        @strongify(self);
        [self->_mainView.tableView reloadData];
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    self.viewModel.active = YES;
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

- (NSString *)mainViewTableViewImageUrl:(NSIndexPath *)indexPath {
    return [self.viewModel imageURLAtIndexPath:indexPath];
}

- (NSString *)mainViewTableViewHeaderTitle:(NSInteger)section {
    return [self.viewModel titleForSection:section];
}


@end




