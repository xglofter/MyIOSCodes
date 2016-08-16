//
//  ZHDRefreshView.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/13.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDRefreshView.h"


#define kRefreshContentOffset     @"contentOffset"

#define fToggleHeight       90.0

#define kDefaultPullTips    @"下拉刷新"
#define kDefaultReleaseTips @"释放更新"

#define fDefaultViewWidth   [[UIScreen mainScreen] bounds].size.width
#define fDefaultViewHeight  100.0
#define fTipsFontSize       14.0

#define fTimeCloseRefreshView  0.5

@interface ZHDRefreshView ()

// TODO: some property should put to public

@property(nonatomic, weak) UIScrollView *scrollView;

@end


@implementation ZHDRefreshView {
    UILabel *_tipsLabel;
    UIActivityIndicatorView *_activityIndicatorView;
    UIImageView *_indicatorImageView;
    ZHDRefreshViewState _refreshState;
    UIEdgeInsets _originalOffsetInsets;
}

- (instancetype)initWithType:(ZHDRefreshViewType)type {

    self = [self initWithFrame:CGRectMake(0,0,fDefaultViewWidth,fDefaultViewHeight)];
    if (self) {

        self.backgroundColor = [UIColor greenColor];
        _tipsPullString = kDefaultPullTips;
        _tipsReleaseString = kDefaultReleaseTips;

        _activityIndicatorView = [UIActivityIndicatorView new];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];

        _indicatorImageView = [UIImageView new];
        _indicatorImageView.image = [UIImage imageNamed:@"refresh_arrow"];
        _indicatorImageView.frame = CGRectMake(0, 0, 20, 50);
        [self addSubview:_indicatorImageView];

        _tipsLabel = [UILabel new];
        _tipsLabel.text = _tipsPullString;
        _tipsLabel.frame = CGRectMake(0, 0, 120, fTipsFontSize + 2);
        _tipsLabel.font = [UIFont systemFontOfSize:fTipsFontSize];
        _tipsLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_tipsLabel];

        [self setRefreshStateTo:ZHDRefreshViewStateDefault];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat superViewCenterX = _scrollView.center.x;
    CGFloat viewHalfHeight = self.frame.size.height * 0.5;
    self.center = CGPointMake(superViewCenterX, -viewHalfHeight);
    _activityIndicatorView.center = CGPointMake(superViewCenterX - 40, viewHalfHeight);
    _indicatorImageView.center = CGPointMake(superViewCenterX - 40, viewHalfHeight);
    _tipsLabel.center = CGPointMake(superViewCenterX + _tipsLabel.frame.size.width * 0.5 - 15, viewHalfHeight);
}

#pragma mark - Public Methods

- (void)addToScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [_scrollView addSubview:self];
    [_scrollView addObserver:self forKeyPath:kRefreshContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)beginRefresh {

}

- (void)endRefresh {
    [UIView animateWithDuration:fTimeCloseRefreshView animations:^{
//        self.scrollView.contentInset = _originalOffsetInsets;
    } completion:^(BOOL finished) {
        [self setRefreshStateTo:ZHDRefreshViewStateDefault];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if (![keyPath isEqualToString:kRefreshContentOffset] || self.scrollView.frame.size.height <= 0 || _refreshState == ZHDRefreshViewStateDidRefresh) return;

    CGFloat fOffsetY = [change[@"new"] CGPointValue].y;
    CGFloat fToggleY = - fToggleHeight - self.scrollView.contentInset.top;  // Header, TODO: Footer

//    NSLog(@"%f - %f", fOffsetY, fToggleY);

    if (fOffsetY <= fToggleY) {
        if (!self.scrollView.isDragging && _refreshState == ZHDRefreshViewStateCanRefresh) {
            // can toggle
            [self setRefreshStateTo:ZHDRefreshViewStateDidRefresh];
            return;
        }

        if (_refreshState == ZHDRefreshViewStateDefault) {
            // did toggle
            [self setRefreshStateTo:ZHDRefreshViewStateCanRefresh];
            return;
        }
    } else {
        if ((_refreshState != ZHDRefreshViewStateDefault) && self.scrollView.isDragging) {
            [self setRefreshStateTo:ZHDRefreshViewStateDefault];
            return;
        }
    }
}

#pragma mark Private Method

- (void)setRefreshStateTo:(ZHDRefreshViewState)state {

    switch (state) {
        case ZHDRefreshViewStateDefault:
            NSLog(@"Default");
            break;
        case ZHDRefreshViewStateCanRefresh:
            NSLog(@"CanRefresh");
            break;
        case ZHDRefreshViewStateDidRefresh:
            NSLog(@"DidRefresh");
            // use this code to send event
            [self sendActionsForControlEvents:UIControlEventValueChanged];

            break;
        default:
            break;
    }
    _refreshState = state;

}




@end
