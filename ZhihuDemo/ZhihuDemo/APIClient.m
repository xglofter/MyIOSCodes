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


@end


@implementation APIClient

+ (void)requestGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters callback:(Callback)callback {

    NSString *a = @"http://dynamic.game.tvos.com/config";
//    NSString *a = @"http://news-at.zhihu.com/api/3/themes";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:a parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic[@"code"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];

}

- (RACSignal *)fetchJSONFromUrl:(NSString *)url {
    return [RACSignal empty];
}

@end
