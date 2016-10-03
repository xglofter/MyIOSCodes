//
//  ZHDMenuView.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMenuView.h"


#define fCategoryTableHeight       kScreenHeight * 0.8  // 分类菜单TableView的高度
#define fCategoryTableSpaceBorder  kScreenHeight * 0.1  // 上下留边的高度


@interface ZHDMenuView () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation ZHDMenuView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        CGRect tableViewFrame = CGRectMake(0, fCategoryTableSpaceBorder, frame.size.width, fCategoryTableHeight);

        self.gradientLayer = [[CAGradientLayer alloc] init];
        self.gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor,
                                      (__bridge id)[[UIColor blackColor]colorWithAlphaComponent:0].CGColor];
        self.gradientLayer.frame = tableViewFrame;
        self.gradientLayer.locations = @[@0.8, @1];
        self.layer.mask = self.gradientLayer;

        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = tableViewFrame;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];

        [self _layoutViews];
    }
    return self;
}

- (void)_layoutViews {

//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self);
//        make.left.equalTo(self);
//
//    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.delegate menuViewTableViewNumberOfRows:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];

    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.text = [self.delegate menuViewTableViewContentTitle:indexPath];

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate menuViewTableViewSelected:indexPath];
}


@end
