//
//  ZHDDetailView.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UICommonHeader.h"

@interface ZHDDetailView : UIView

@property(nonatomic, strong) UIWebView * webView; // TODO: make it private

- (void)loadHTMLString:(NSString *)content;

- (void)backPage;

@end
