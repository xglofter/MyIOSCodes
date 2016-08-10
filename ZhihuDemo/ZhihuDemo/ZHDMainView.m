//
//  ZHDMainView.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMainView.h"

@interface ZHDMainView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZHDMainView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];

        [self _layoutViews];
    }
    return self;
}

- (void)_layoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return fArticleTableHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return fArticleTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate mainViewTableViewSelected:indexPath];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.delegate mainViewTableViewNumberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.delegate mainViewTableViewNumberOfRows:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *Identifier = @"Identifier";
    //    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];

    cell.textLabel.text = [self.delegate mainViewTableViewContentTitle:indexPath];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.delegate mainViewTableViewHeaderTitle:section];
}



@end
