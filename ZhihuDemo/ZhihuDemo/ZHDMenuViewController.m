//
//  ZHDMenuViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/5.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMenuViewController.h"

#import "ZHDMenuView.h"

@interface ZHDMenuViewController () <ZHDMenuViewDelegate> {
    ZHDMenuView *_menuView;
}
@end

@implementation ZHDMenuViewController

- (void)loadView {
    _menuView = [[ZHDMenuView alloc] init];
    _menuView.delegate = self;
    self.view = _menuView;

}

- (void)viewDidLoad {
    [super viewDidLoad];

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
    return 9;
}

- (NSString *)menuViewTableViewContentTitle:(NSIndexPath *)indexPath {
    NSString *text;
    if (indexPath.row == 0) {
        text = @"首页";
    } else if (indexPath.row == 1) {
        text = @"日常心里学";
    } else if (indexPath.row == 2) {
        text = @"用户推荐日报";
    } else if (indexPath.row == 3) {
        text = @"电影日报";
    } else if (indexPath.row == 4) {
        text = @"不许无聊";
    } else if (indexPath.row == 5) {
        text = @"设计日报";
    } else if (indexPath.row == 6) {
        text = @"大公司日报";
    } else if (indexPath.row == 7) {
        text = @"财经日报";
    } else if (indexPath.row == 8) {
        text = @"互联网安全";
    }
    return text;
}



@end
