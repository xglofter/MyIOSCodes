//
//  APIClient.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "APIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

@interface APIClient()

+ (void)requestGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters callback:(Callback)callback;

@end


@implementation APIClient

+ (void)requestGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters callback:(Callback)callback {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        callback(@YES, dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        callback(@NO, error);
    }];
}


#pragma mark Public-Methods

+ (RACSignal *)fetchJSONFromUrl:(NSString *)url parameters:(NSDictionary *)parameters {

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        [self requestGetWithUrl:url parameters:parameters callback:^(BOOL isSuccess, id msg) {
            if (isSuccess) {
                [subscriber sendNext:msg];
            } else {
                [subscriber sendError:(NSError *)msg];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)requestLogin {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"Login OK!"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

@end
