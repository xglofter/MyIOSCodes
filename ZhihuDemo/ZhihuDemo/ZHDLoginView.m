//
//  ZHDLoginView.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/9.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDLoginView.h"


@interface ZHDLoginView ()

@end


@implementation ZHDLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = kColorView;

        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"splash_logo"];
        [self addSubview:_logoImageView];

        _numberTextField = [[UITextField alloc] init];
        _numberTextField.backgroundColor = [UIColor whiteColor];
        _numberTextField.placeholder = @"输入手机号";
        _numberTextField.layer.cornerRadius = fCornerRadius;
        _numberTextField.layer.masksToBounds = true;
        [self addSubview:_numberTextField];

        _passwordField = [[UITextField alloc] init];
        _passwordField.backgroundColor = [UIColor whiteColor];
        _passwordField.placeholder = @"输入密码";
        _passwordField.layer.cornerRadius = fCornerRadius;
        _passwordField.layer.masksToBounds = true;
        _passwordField.secureTextEntry = true;
        [self addSubview:_passwordField];

        _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginButton.layer.cornerRadius = fCornerRadius;
        _loginButton.layer.masksToBounds = true;
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
        [self addSubview:_loginButton];

        [self _layoutViews];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseKeyboard:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)_layoutViews {
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(100);
//        make.size.equalTo(@[@150, @150]);
    }];

    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom).offset(40);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(fTextFieldHeight));
    }];

    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberTextField.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(fTextFieldHeight));
    }];

    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordField.mas_bottom).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@(fButtonHeight));
    }];
}


- (void)onCloseKeyboard:(UITapGestureRecognizer *)tap {
    [_numberTextField resignFirstResponder];
    [_passwordField resignFirstResponder];
}


@end






