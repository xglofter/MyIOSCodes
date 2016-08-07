//
//  ZHDVCWithMenu.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/5.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UICommonHeader.h"

#define kMainPageDistance 100   // 打开Menu时，MainVC露出的宽度
#define kMainPageScale    0.8   // 打开Menu时，MainVC缩放比例
#define kMainPageCenter   CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale * 0.5 - kMainPageDistance, kScreenHeight * 0.5)

#define fSlideChangeStateDistance  (kScreenWidth - kMainPageDistance) * 0.5 - 40 // 滑动距离大于此数时，Menu开或关
#define fSlideSpeed       0.7  // 滑动速度

#define fMenuMaskMinAlpha 0.2
#define fMenuMaskMaxAlpha 0.9
#define fMenuCenterX      30   // 左侧初始偏移量
#define fMenuScale        0.7  // 左侧初始缩放比例

@interface ZHDVCWithMenu : UIViewController

@property(nonatomic, assign) BOOL isClosed;
@property(nonatomic, strong) UIViewController *mainVC;
@property(nonatomic, strong) UIViewController *leftMenuVC;

- (instancetype)initWithLeftVC:(UIViewController *)leftVC
                     andMainVC:(UIViewController *)mainVC;

- (void)setPanGestureEnable:(BOOL)enabled;

- (void)openMenuView;

- (void)closeMenuView;

@end
