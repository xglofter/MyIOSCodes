//
//  ZHDMainView.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UICommonHeader.h"

@protocol ZHDMainViewDelegate <NSObject>

- (void)mainViewTableViewSelected:(NSIndexPath *)indexPath;
- (NSInteger)mainViewTableViewNumberOfSections;
- (NSInteger)mainViewTableViewNumberOfRows:(NSInteger)section;
- (NSString *)mainViewTableViewContentTitle:(NSIndexPath *)indexPath;
- (NSString *)mainViewTableViewHeaderTitle:(NSInteger)section;

@end

@interface ZHDMainView : UIView

@property(nonatomic, weak) id<ZHDMainViewDelegate> delegate;
@property(nonatomic, strong) UITableView *tableView;

@end
