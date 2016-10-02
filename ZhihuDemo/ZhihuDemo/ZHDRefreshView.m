//
//  ZHDRefreshView.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/13.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDRefreshView.h"


#define kRefreshContentOffset     @"contentOffset"

#define kDefaultPullTips       @"下拉刷新"
#define kDefaultPullTipsFooter @"上拉刷新"
#define kDefaultReleaseTips    @"释放更新"
#define kDefaultRefreshTips    @"更新中"

#define fDefaultViewWidth   [[UIScreen mainScreen] bounds].size.width
#define fDefaultViewHeight  80.0
#define fTipsFontSize       14.0
#define fToggleHeight       70.0

#define fTimeCloseRefreshView  0.5

@interface ZHDRefreshView ()

@property(nonatomic, weak) UIScrollView *scrollView;

@end


@implementation ZHDRefreshView {
    UILabel *_tipsLabel;
    UIActivityIndicatorView *_activityIndicatorView;
    UIImageView *_indicatorImageView;
    ZHDRefreshViewState _refreshState;
    UIEdgeInsets _originalContentInsets;
    BOOL _hasKeepOriginContentInsets;
}

- (instancetype)initWithType:(ZHDRefreshViewType)type {

    self = [self initWithFrame:CGRectMake(0,0,fDefaultViewWidth,fDefaultViewHeight)];
    if (self) {
        self.type = type;

        //self.backgroundColor = [UIColor greenColor];
        _tipsPullString = (_type == ZHDRefreshViewTypeHeader) ? kDefaultPullTips : kDefaultPullTipsFooter;
        _tipsReleaseString = kDefaultReleaseTips;
        _tipsRefreshString = kDefaultRefreshTips;

        _activityIndicatorView = [UIActivityIndicatorView new];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_activityIndicatorView];

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

        _hasKeepOriginContentInsets = NO;
        [self setRefreshStateTo:ZHDRefreshViewStateDefault];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat superViewCenterX = _scrollView.center.x;
    CGFloat viewHalfHeight = self.frame.size.height * 0.5;
    if (_type == ZHDRefreshViewTypeHeader) {
        self.center = CGPointMake(superViewCenterX, -viewHalfHeight);
    } else {
        NSLog(@">>>>> %f", _scrollView.contentSize.height); // 注意，UITableView的contentSize比较特殊，和scrollview不同
        self.center = CGPointMake(superViewCenterX, _scrollView.contentSize.height + viewHalfHeight);
    }
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

- (void)endRefresh {
    [UIView animateWithDuration:fTimeCloseRefreshView animations:^{
        self.scrollView.contentInset = _originalContentInsets;
    } completion:^(BOOL finished) {
        [self setRefreshStateTo:ZHDRefreshViewStateDefault];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if (![keyPath isEqualToString:kRefreshContentOffset] || self.scrollView.frame.size.height <= 0 || _refreshState == ZHDRefreshViewStateDidRefresh) return;

    CGFloat fOffsetY = [change[@"new"] CGPointValue].y;
    CGFloat fToggleY = -fToggleHeight - self.scrollView.contentInset.top;  // Header, TODO: Footer

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
            [self rotateIndicator:YES];
            [self showActivityIndicator:NO];
            break;
        case ZHDRefreshViewStateCanRefresh:
            NSLog(@"CanRefresh");
            [self rotateIndicator:NO];
            break;
        case ZHDRefreshViewStateDidRefresh:
            NSLog(@"Refreshing");
            if (!_hasKeepOriginContentInsets) {
                _originalContentInsets = self.scrollView.contentInset;
                _hasKeepOriginContentInsets = YES;
            }

//          _original + UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0); // for Header

            self.scrollView.contentInset = UIEdgeInsetsMake(_originalContentInsets.top + self.frame.size.height, _originalContentInsets.left, _originalContentInsets.bottom, _originalContentInsets.right);

            [self showActivityIndicator:YES];

            _tipsLabel.text = _tipsRefreshString;

            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
        default:
            break;
    }
    _refreshState = state;

}

- (void)rotateIndicator:(BOOL)isDefaultState {

    CGFloat fAngle = 0.0;
    if (isDefaultState) {
        fAngle = (_type == ZHDRefreshViewTypeHeader) ? 0 : M_PI-0.0001;
        _tipsLabel.text = _tipsPullString;
    } else {
        fAngle = (_type == ZHDRefreshViewTypeHeader) ? M_PI-0.0001 : 0;
        _tipsLabel.text = _tipsReleaseString;
    }
    [UIView animateWithDuration:0.5 animations:^{
        _indicatorImageView.transform = CGAffineTransformMakeRotation(fAngle);
    }];
}

- (void)showActivityIndicator:(BOOL)isUse {
    if (isUse) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
    _indicatorImageView.hidden = isUse;
    _activityIndicatorView.hidden = !isUse;

}



@end
