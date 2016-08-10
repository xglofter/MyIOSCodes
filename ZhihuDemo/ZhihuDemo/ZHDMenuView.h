//
//  ZHDMenuView.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UICommonHeader.h"

@protocol ZHDMenuViewDelegate <NSObject>

- (void)menuViewTableViewSelected:(NSIndexPath *)indexPath;
- (NSInteger)menuViewTableViewNumberOfRows:(NSInteger)section;
- (NSString *)menuViewTableViewContentTitle:(NSIndexPath *)indexPath;

@end

@interface ZHDMenuView : UIView

@property(nonatomic, weak) id<ZHDMenuViewDelegate> delegate;
@property(nonatomic, strong) UITableView* tableView;

@end
