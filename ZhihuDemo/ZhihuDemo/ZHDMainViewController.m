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
#import "APIClient.h"

@interface ZHDMainViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

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

    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    @weakify(self);
    [self.viewModel.updateTableSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    // TEST
    [APIClient requestGetWithUrl:@"http://example.com" parameters:nil callback:^(BOOL isSuccess, id msg) {
        NSLog(@"%c, %@", isSuccess, msg);
    }];
}

- (void)onMenuAction {
    NSLog(@"onMenuAction");

    [self.parentVC openMenuView]; // open the Menu
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return fArticleTableHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return fArticleTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath %@", indexPath);
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *Identifier = @"Identifier";
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    cell.textLabel.text = [self.viewModel titleAtIndexPath:indexPath];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleForSection:section];
}



@end




