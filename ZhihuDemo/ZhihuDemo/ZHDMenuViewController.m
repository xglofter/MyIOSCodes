//
//  ZHDMenuViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/5.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMenuViewController.h"


@interface ZHDMenuViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView* tableView;

@end

@implementation ZHDMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];

    if (indexPath.row == 0) {
        cell.textLabel.text = @"首页";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"日常心里学";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"用户推荐日报";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"电影日报";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"不许无聊";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"设计日报";
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"大公司日报";
    } else if (indexPath.row == 7) {
        cell.textLabel.text = @"财经日报";
    } else if (indexPath.row == 8) {
        cell.textLabel.text = @"互联网安全";
    }
    return cell;
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return fCategoryTableCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return fCategoryTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView selected");

//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    otherViewController *vc = [[otherViewController alloc] init];
//    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
//
//    [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
}





@end
