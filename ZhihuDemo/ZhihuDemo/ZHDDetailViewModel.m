//
//  ZHDDetailViewModel.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "APIClient.h"

@interface ZHDDetailViewModel ()

@property(nonatomic, strong) NSNumber* newsId;

@end

@implementation ZHDDetailViewModel

- (instancetype)initWithModel:(id)model {

    self.newsId = (NSNumber *)model;
    self.updateTableSignal = [[RACSubject subject] setNameWithFormat:@"ZHDDetailViewModel updateTableSignal"];

    @weakify(self);
    // @NOTE: signal send when set active = YES
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self _fetchDatas];
    }];

    return self;
}

- (void)_fetchDatas {

    NSString *url = [NSString stringWithFormat:kUrlNewsContent, self.newsId];
    RACSignal *test = [APIClient fetchJSONFromUrl:url parameters:nil];
    [test subscribeNext:^(id x) {

        // TODO: 新建一个fetchStringFromUrl

        NSString *body = (NSString *)[(NSDictionary *)x objectForKey:@"body"];
//        NSLog(@"%@", body);
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *stringJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", stringJson);

        // send update signal
        [(RACSubject *)self.updateTableSignal sendNext:body];
    }];
}


@end


