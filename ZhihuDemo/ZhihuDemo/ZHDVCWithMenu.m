//
//  ZHDVCWithMenu.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/5.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDVCWithMenu.h"

@interface ZHDVCWithMenu () {
    CGFloat _offsetX;  // current move offset on X-coordinate
    CGFloat _speedX;
}

@property(nonatomic, strong) UIPanGestureRecognizer *panGR;
@property(nonatomic, strong) UITapGestureRecognizer *tapGR;

@property(nonatomic, strong) UIView *maskView;

@end


#pragma mark Public Methods

@implementation ZHDVCWithMenu

- (instancetype)initWithLeftVC:(UIViewController *)leftVC
                     andMainVC:(UIViewController *)mainVC {
    if (self = [super init]) {

        _leftMenuVC = leftVC;
        _mainVC = mainVC;

        [self addChildViewController:_leftMenuVC];
        [self addChildViewController:_mainVC];

        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onHandlePanAction:)];
        [self.view addGestureRecognizer:_panGR];

        // menu background image
        UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
        background.image = [UIImage imageNamed:@"leftbackimage"];
        [self.view addSubview:background];

        // menu
        _maskView = [[UIView alloc] init];
        _maskView.frame = self.leftMenuVC.view.bounds;
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = fMenuMaskMinAlpha;
        [self.view addSubview:_maskView];

        // menu and main view
        [self.view addSubview:self.leftMenuVC.view];
        [self.view addSubview:self.mainVC.view];

        // init layout
        self.leftMenuVC.view.center = CGPointMake(fMenuCenterX, kScreenHeight * 0.5);
        self.leftMenuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, fMenuScale, fMenuScale);

        self.isClosed = YES;
        _speedX = fSlideSpeed;
    }
    return self;
}

- (void)setPanGestureEnable:(BOOL)enabled {
    if (_panGR != nil) {
        _panGR.enabled = enabled;
    }
}

- (void)openMenuView {

    // open translate animation
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, kMainPageScale, kMainPageScale);
    self.mainVC.view.center = kMainPageCenter;

    self.leftMenuVC.view.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    self.leftMenuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);

    self.maskView.alpha = fMenuMaskMinAlpha;
    [UIView commitAnimations];

    self.isClosed = NO;

    // set MainVC interaction disabled
    for (UIView *tempView in [self.mainVC.view subviews]) {
        tempView.userInteractionEnabled = false;
    }

    [self addTapGesture];
}

- (void)closeMenuView {

    // open translate animation
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    self.mainVC.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);

    self.leftMenuVC.view.center = CGPointMake(fMenuCenterX, kScreenHeight * 0.5);
    self.leftMenuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, fMenuScale, fMenuScale);

    self.maskView.alpha = fMenuMaskMaxAlpha;
    [UIView commitAnimations];

    self.isClosed = YES;

    // set MenuVC interaction enabled
    for (UIView *tempView in [self.mainVC.view subviews]) {
        tempView.userInteractionEnabled = true;
    }

    [self removeTapGesture];
}

#pragma mark Private Methods

- (void)onHandlePanAction:(UIPanGestureRecognizer *)pan {

    CGPoint point = [pan translationInView:self.view];
    _offsetX = (point.x * _speedX + _offsetX);

    CGFloat fCurMainOriginX = self.mainVC.view.frame.origin.x;
    CGFloat fMaxMainMoveX = kScreenWidth - kMainPageDistance;
    CGFloat fMovePercent = fCurMainOriginX / fMaxMainMoveX;
    NSLog(@"fMovePercent: %f", fMovePercent);

    BOOL needMoveWithTap = YES;
    if (((fCurMainOriginX <= 0) && (_offsetX <= 0)) || ((fCurMainOriginX >= fMaxMainMoveX) && (_offsetX >= 0))) {
        _offsetX = 0;
        needMoveWithTap = NO;
    }

    if (needMoveWithTap && (fCurMainOriginX >= 0) && (fCurMainOriginX <= fMaxMainMoveX)) {

        CGFloat recCenterX = self.mainVC.view.center.x + point.x * _speedX;
        if (recCenterX < kScreenWidth * 0.5 - 2) {
            recCenterX = kScreenWidth * 0.5;
        }

        CGFloat recCenterY = self.mainVC.view.center.y;

        self.mainVC.view.center = CGPointMake(recCenterX,recCenterY);

        CGFloat scale = 1 - (1 - kMainPageScale) * fMovePercent;
        self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];

        CGFloat leftTabCenterX = fMenuCenterX + ((kScreenWidth) * 0.5 - fMenuCenterX) * fMovePercent;
        CGFloat leftScale = fMenuScale + (1 - fMenuScale) * fMovePercent;
        self.leftMenuVC.view.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
        self.leftMenuVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);

        CGFloat tempAlpha = fMenuMaskMaxAlpha - (fMenuMaskMaxAlpha - fMenuMaskMinAlpha) * fMovePercent;
        self.maskView.alpha = tempAlpha;
    }
    else { // out of range
        if (fCurMainOriginX < 0) {
            [self closeMenuView];
            _offsetX = 0;
        }
        else if (fCurMainOriginX > fMaxMainMoveX) {
            [self openMenuView];
            _offsetX = 0;
        }
    }

    // touch end
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (fabs(_offsetX) > fSlideChangeStateDistance) {
            if (self.isClosed) {
                [self openMenuView];
            }
            else {
                [self closeMenuView];
            }
        }
        else {
            if (self.isClosed) {
                [self closeMenuView];
            }
            else {
                [self openMenuView];
            }
        }
        _offsetX = 0;
    }
}

- (void)onHandleTapAction:(UITapGestureRecognizer *)tap {
    _offsetX = 0;
    [self closeMenuView];
}

- (void)removeTapGesture {
    [self.mainVC.view removeGestureRecognizer:_tapGR];
    _tapGR = nil;
}

- (void)addTapGesture {
    _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHandleTapAction:)];
    _tapGR.numberOfTouchesRequired = 1;

    [self.mainVC.view addGestureRecognizer:_tapGR];
    _tapGR.cancelsTouchesInView = YES;
}

@end

