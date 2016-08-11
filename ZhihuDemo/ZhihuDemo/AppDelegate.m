//
//  AppDelegate.m
//  ZhihuDemo
//
//  Created by guang xu on 16/7/26.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHDCoreDataStack.h"
#import "ZHDVCWithMenu.h"
#import "ZHDMainViewController.h"
#import "ZHDMainViewModel.h"
#import "ZHDMenuViewController.h"
#import "ZHDMenuViewModel.h"
#import "ZHDLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    ZHDMenuViewController *menuVC = [[ZHDMenuViewController alloc] init];
    ZHDMenuViewModel *menuViewModel = [[ZHDMenuViewModel alloc] initWithModel:@""];
    menuVC.viewModel = menuViewModel;
    ZHDMainViewController *mainVC = [[ZHDMainViewController alloc] init];
    ZHDMainViewModel *mainVM = [[ZHDMainViewModel alloc] initWithModel:@""];
    mainVC.viewModel = mainVM;
    UINavigationController *mainNavivation = [[UINavigationController alloc] initWithRootViewController:mainVC];

    ZHDVCWithMenu *mainVCWithMenu = [[ZHDVCWithMenu alloc] initWithLeftVC:menuVC andMainVC:mainNavivation];
    mainVC.parentVC = mainVCWithMenu;

    self.window.rootViewController = mainVCWithMenu;

    // TEST
//    ZHDLoginViewController *loginVC = [[ZHDLoginViewController alloc] init];
//    self.window.rootViewController = loginVC;

    // color scheme
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    [self.window makeKeyAndVisible];

    [[ZHDCoreDataStack defaultStack] ensureInitialLoad];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[ZHDCoreDataStack defaultStack] saveContext];
}


@end
