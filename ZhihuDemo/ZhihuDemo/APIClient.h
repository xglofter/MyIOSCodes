//
//  APIClient.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>


// current api is 7

static NSString * kUrlStartImage     = @"http://news-at.zhihu.com/api/4/start-image/1080*1776"; /*320*432  480*728  720*1184  1080*1776*/
static NSString * kUrlLatestNews     = @"http://news-at.zhihu.com/api/4/news/latest"; //get latest news
static NSString * kUrlBeforeNews     = @"http://news.at.zhihu.com/api/4/news/before/%@"; //add date(20160809)
static NSString * kUrlNewsContent    = @"http://news-at.zhihu.com/api/4/news/%@"; //add news id
static NSString * kUrlExtra          = @"http://news-at.zhihu.com/api/4/story-extra/#%@"; //add news id
static NSString * kUrlLongComments   = @"http://news-at.zhihu.com/api/4/story/#%@/long-comments"; //add news id
static NSString * kUrlShortComments  = @"http://news-at.zhihu.com/api/4/story/#%@/short-comments"; //add news id
static NSString * kUrlThemes         = @"http://news-at.zhihu.com/api/4/themes"; //get all themes
static NSString * kUrlThemeContent   = @"http://news-at.zhihu.com/api/4/theme/%@"; //add theme id
static NSString * kUrlHotNews        = @"http://news-at.zhihu.com/api/3/news/hot";
static NSString * kUrlSections       = @"http://news-at.zhihu.com/api/3/sections"; //get all sections
static NSString * kUrlSectionContent = @"http://news-at.zhihu.com/api/3/section/%@"; //add section id
static NSString * kUrlSectionBefore  = @"http://news-at.zhihu.com/api/4/section/%@/before/%@"; //add section id and timestamp


typedef void(^Callback)(BOOL isSuccess, id msg);

@class RACSignal;

@interface APIClient : NSObject

+ (void)requestGetWithUrl:(NSString *)url parameters:(NSDictionary *)parameters callback:(Callback)callback;

- (RACSignal *)fetchJSONFromUrl:(NSString *)url;


@end
