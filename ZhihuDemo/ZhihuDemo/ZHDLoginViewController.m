//
//  ZHDLoginViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/9.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDLoginViewController.h"
#import "ZHDLoginView.h"

#import "APIClient.h"

@implementation ZHDLoginViewController {
    ZHDLoginView *_mainView;
}

- (void)loadView {
    _mainView = [[ZHDLoginView alloc] init];
    self.view = _mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_mainView.loginButton addTarget:self action:@selector(onLoginAction:) forControlEvents:UIControlEventTouchUpInside];

    [self _setupLoginEnableSignal];

    // TEST
    RACSignal *test = [APIClient fetchJSONFromUrl:kUrlThemes parameters:nil];
    [test subscribeNext:^(id x) {
        NSLog(@">>>: %@", x);
    }];
}


- (void)_setupLoginEnableSignal {

    RACSignal *numberSignal = [_mainView.numberTextField.rac_textSignal map:^id(NSString *numberText) {
        NSUInteger length = numberText.length;
        if (length >= 1 && length <= 16) {
            return @(YES);
        }
        return @(NO);
    }];

    RACSignal *passwordSignal = [_mainView.passwordField.rac_textSignal map:^id(NSString *passwordText) {
        NSUInteger length = passwordText.length;
        if (length >= 1 && length <= 16) {
            return @(YES);
        }
        return @(NO);
    }];

    RAC(_mainView.loginButton, enabled) = [RACSignal combineLatest:@[numberSignal, passwordSignal] reduce:^(NSNumber *isNumberValid, NSNumber *isPasswordValid){
        return @(isNumberValid.boolValue && isPasswordValid.boolValue);
    }];
}

- (void)onLoginAction:(UIButton *)sender {

    RACSignal *signalLogin = [APIClient requestLogin];
    [signalLogin subscribeNext:^(NSString *msg) {
        NSLog(@"login: %@", msg);
    }];

}


@end
