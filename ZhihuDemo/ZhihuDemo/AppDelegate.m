//
//  AppDelegate.m
//  ZhihuDemo
//
//  Created by guang xu on 16/7/26.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHDCoreDataStack.h"
#import "ZHDMainViewController.h"
#import "ZHDVCWithMenu.h"
#import "ZHDMenuViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    ZHDMenuViewController *menuVC = [[ZHDMenuViewController alloc] init];
    ZHDMainViewController *mainVC = [[ZHDMainViewController alloc] init];
    UINavigationController *mainNavivation = [[UINavigationController alloc] initWithRootViewController:mainVC];

    ZHDVCWithMenu *mainVCWithMenu = [[ZHDVCWithMenu alloc] initWithLeftVC:menuVC andMainVC:mainNavivation];
    mainVC.parentVC = mainVCWithMenu;

    self.window.rootViewController = mainVCWithMenu;

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
