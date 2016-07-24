//
//  XGGNoteViewController.m
//  Memo
//
//  Created by Richard on 16/7/16.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "XGGNoteViewController.h"
#import <Masonry.h>


@interface XGGNoteViewController ()

@property(nonatomic, strong) UITextField *textField;

@end

@implementation XGGNoteViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // back to last viewcontroller
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"ic_back"]
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onBackAction:)];
    self.navigationItem.leftBarButtonItem = backBarItem;
    self.navigationItem.title = @"新建";
    self.view.backgroundColor = [UIColor whiteColor];

    // text input this textField
    _textField = [[UITextField alloc] init];
    _textField.placeholder = @"input something";
    [self.view addSubview:_textField];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationHeight = self.navigationController.navigationBar.frame.size.height;

    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight + navigationHeight + 10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBackAction:(UIBarButtonItem *)sender {
    NSLog(@"back action");

    NSString *content = self.textField.text;
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:content
                                                         forKey:@"content"];

    // pass value way 1
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"AddNewNote"
     object:nil
     userInfo:dataDict];

    // pass value way 2
    // [self.delegate passValue:dataDict];

    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
