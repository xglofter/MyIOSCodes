//
//  ZHDMenuViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/5.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMenuViewController.h"
#import "ZHDMenuView.h"
#import "ZHDMenuViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZHDMenuViewController () <ZHDMenuViewDelegate>

@property(nonatomic, strong) ZHDMenuView *menuView;

@end

@implementation ZHDMenuViewController

- (void)loadView {
    _menuView = [[ZHDMenuView alloc] init];
    _menuView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _menuView.delegate = self;
    self.view = _menuView;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);
    [self.viewModel.updateTableSignal subscribeNext:^(id x) {
        @strongify(self);
        [self->_menuView.tableView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {

    self.viewModel.active = YES;
}


#pragma mark - ZHDMenuViewDelegate

- (void)menuViewTableViewSelected:(NSIndexPath *)indexPath {
    NSLog(@"menuViewTableView selected");
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    otherViewController *vc = [[otherViewController alloc] init];
//    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//
//    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}

- (NSInteger)menuViewTableViewNumberOfRows:(NSInteger)section {
    return [self.viewModel numberOfItems];
}

- (NSString *)menuViewTableViewContentTitle:(NSIndexPath *)indexPath {
    return [self.viewModel titleAtIndexPath:indexPath];
}



@end
