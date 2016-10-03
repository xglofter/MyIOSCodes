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
//        _webView.scalesPageToFit = YES;
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
//    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
//    [webView stringByEvaluatingJavaScriptFromString:meta];

    //拦截网页图片  并修改图片大小

    CGFloat fWidth = self.frame.size.width - 15;
    NSString *jsFormat = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth=%f;" //缩放系数
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = maxwidth;"
    "myimg.height = myimg.height * (maxwidth/oldwidth);"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    NSString *jsString = [[NSString alloc]initWithFormat:jsFormat, fWidth];
    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"didFailLoadWithError");
}


@end
