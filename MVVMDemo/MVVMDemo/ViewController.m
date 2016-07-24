//
//  ViewController.m
//  MVVMDemo
//
//  Created by Richard on 16/7/9.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ViewController.h"

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self obtainData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)obtainData {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;

//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    configuration.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json; charset=utf-8"};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:@"http://dynamic.game.tvos.com/config"
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"success - %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-> %@", error);
    }];

}

@end
