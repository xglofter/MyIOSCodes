//
//  ZHDRefreshView.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/13.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZHDRefreshViewType) {
    ZHDRefreshViewTypeHeader, // can use to UITableView's header view also
    ZHDRefreshViewTypeFooter
};

typedef NS_ENUM(NSInteger, ZHDRefreshViewState) {
    ZHDRefreshViewStateDefault,
    ZHDRefreshViewStateCanRefresh,
    ZHDRefreshViewStateDidRefresh,
};

@interface ZHDRefreshView : UIControl

@property(nonatomic, copy) NSString *tipsPullString;
@property(nonatomic, copy) NSString *tipsReleaseString;
@property(nonatomic, copy) NSString *tipsRefreshString;

@property(nonatomic, assign) ZHDRefreshViewType type;

- (instancetype)initWithType:(ZHDRefreshViewType)type;
- (void)addToScrollView:(UIScrollView *)scrollView;
- (void)endRefresh;

@end
