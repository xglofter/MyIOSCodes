//
//  APIClient.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>


@interface APIClient : NSObject

- (RACSignal *)fetchJSONFromUrl:(NSString *)url;

@end
