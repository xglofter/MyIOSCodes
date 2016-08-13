//
//  ZHDRefreshView.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/13.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZHDRefreshViewType) {
    ZHDRefreshViewTypeHeader,
    ZHDRefreshViewTypeFooter
};

@interface ZHDRefreshView : UIControl

@property(nonatomic, copy) NSString *tipsPullString;
@property(nonatomic, copy) NSString *tipsReleaseString;

- (instancetype)initWithType:(ZHDRefreshViewType)type;
- (void)addToScrollView:(UIScrollView *)scrollView;
- (void)beginRefresh;
- (void)endRefresh;

@end
