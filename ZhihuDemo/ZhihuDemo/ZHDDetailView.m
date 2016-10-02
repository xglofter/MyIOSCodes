//
//  ZHDDetailView.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDDetailView.h"

@interface ZHDDetailView() <UIWebViewDelegate>

@end

@implementation ZHDDetailView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        _webView = [[UIWebView alloc] init];
        [self addSubview:_webView];

        [self _layoutViews];

        [_webView setUserInteractionEnabled:YES];

        [_webView setDelegate:self];

        
    }
    return self;
}

- (void)_layoutViews {

    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)loadHTMLString:(NSString *)content {
    //        NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [_webView loadHTMLString:content baseURL:nil];
}

- (void)backPage {

}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSLog(@"%ld", (long)navigationType);

    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
            NSLog(@"Click");
            [webView stopLoading];
            return NO;
        case UIWebViewNavigationTypeFormSubmitted:
            NSLog(@"Submitted");
            break;
        case UIWebViewNavigationTypeBackForward:
            NSLog(@"BackForward");
            break;
        case UIWebViewNavigationTypeReload:
            NSLog(@"Reload");
            break;
        case UIWebViewNavigationTypeFormResubmitted:
            NSLog(@"Resubmitted");
            break;
        case UIWebViewNavigationTypeOther:
            NSLog(@"Other");
        default:
            break;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"didFailLoadWithError");
}


@end
