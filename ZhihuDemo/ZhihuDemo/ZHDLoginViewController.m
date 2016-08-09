//
//  ZHDLoginViewController.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/9.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDLoginViewController.h"
#import "ZHDLoginView.h"

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

    [self setupLoginEnableSignal];

}


- (void)setupLoginEnableSignal {

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

    RACSignal *signalLogin = [self requestLogin];
//    [signalLogin subscribeNext:^(NSString *msg) {
//        NSLog(@"login: %@", msg);
//    }];

    RACSignal *signal2 = [self request2];

    [[signalLogin concat:signal2] subscribeNext:^(id x) {

        NSLog(@"%@", x);
    }];
}

// TODO: just test
- (RACSignal *)requestLogin {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"Login OK!"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}


- (RACSignal *)request2 {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [subscriber sendNext:@"请求2完成"];
            [subscriber sendCompleted];
        });

        return nil;
    }];
}


@end
