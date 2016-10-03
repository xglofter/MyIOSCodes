//
//  ZHDMainViewModel.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMainViewModel.h"
#import "APIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ZHDNews.h"


@interface ZHDMainViewModel ()

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSMutableArray *topNewsArray;

@end


@implementation ZHDMainViewModel

- (instancetype)initWithModel:(id)model {

    _topNewsArray = [[NSMutableArray alloc] init];

    self.updateTableSignal = [[RACSubject subject] setNameWithFormat:@"ZHDMainViewModel updateTableSignal"];

    [self.didBecomeActiveSignal subscribeNext:^(id x) {

        [self _fetchNewsDatas];
    }];

    return self;
}

- (ZHDNews *)getCellAtIndexPath:(NSIndexPath *)indexPath {
    return ((ZHDNews *)self.topNewsArray[indexPath.row]);
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return _topNewsArray.count;
}

- (NSString *)titleForSection:(NSInteger)section {
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyy-MM-dd"];
    return [format stringFromDate:self.date];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    return ((ZHDNews *)[_topNewsArray objectAtIndex:indexPath.row]).title;
}

- (NSString *)subTitleAtIndexPath:(NSIndexPath *)indexPath {
    return @"";
}

- (NSString *)imageURLAtIndexPath:(NSIndexPath *)indexPath {
    return ((ZHDNews *)[_topNewsArray objectAtIndex:indexPath.row]).imageUrl;
}


#pragma mark Private Methods

// TODO: update the tableView's data
// use [(RACSubject *)self.updateTableSignal sendNext:nil]

- (void)_fetchNewsDatas {

    RACSignal *test = [APIClient fetchJSONFromUrl:kUrlLatestNews parameters:nil];
    [test subscribeNext:^(id x) {
        NSLog(@"%@", x);
        NSDictionary *newsLatestDict = (NSDictionary *)x;

        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyyMMdd"];
        self.date = [format dateFromString:newsLatestDict[@"date"]];

        for (NSDictionary *news in newsLatestDict[@"top_stories"]) {  // top 5
            ZHDNews *tempNews = [[ZHDNews alloc] init];
            tempNews.id = news[@"id"];
            tempNews.title = news[@"title"];
            tempNews.imageUrl = news[@"image"];
            [_topNewsArray addObject:tempNews];
        }
        // send update signal
        [(RACSubject *)self.updateTableSignal sendNext:nil];
    }];
}

@end
