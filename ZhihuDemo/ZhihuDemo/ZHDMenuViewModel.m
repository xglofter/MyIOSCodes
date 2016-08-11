//
//  ZHDMenuViewModel.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/11.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMenuViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "APIClient.h"
#import "ZHDTheme.h"

@interface ZHDMenuViewModel () {
    NSMutableArray *themes;
}

@end

@implementation ZHDMenuViewModel

- (instancetype)initWithModel:(id)model {

    themes = [[NSMutableArray alloc] init];

    self.updateTableSignal = [[RACSubject subject] setNameWithFormat:@"ZHDMenuViewModel updateTableSignal"];

    @weakify(self);
    // @NOTE: signal send when set active = YES
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self _fetchDatas];
    }];

    return self;
}

- (NSInteger)numberOfItems {
    return themes.count;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    return ((ZHDTheme *)[themes objectAtIndex:indexPath.row]).name;
}

- (NSString *)subTitleAtIndexPath:(NSIndexPath *)indexPath {
    return ((ZHDTheme *)[themes objectAtIndex:indexPath.row]).descrip;
}

- (NSString *)imageURLAtIndexPath:(NSIndexPath *)indexPath {
    return ((ZHDTheme *)[themes objectAtIndex:indexPath.row]).imageUrl;
}


#pragma mark - Private Methods

- (void)_fetchDatas {

    // TEST
    RACSignal *test = [APIClient fetchJSONFromUrl:kUrlThemes parameters:nil];
    [test subscribeNext:^(id x) {

        NSDictionary *themeDict = (NSDictionary *)x;
        for (NSDictionary *theme in themeDict[@"others"]) {
            ZHDTheme *tempTheme = [[ZHDTheme alloc] init];
            tempTheme.id = theme[@"id"];
            tempTheme.name = theme[@"name"];
            tempTheme.descrip = theme[@"description"];
            tempTheme.imageUrl = theme[@"thumbnail"];
            tempTheme.color = theme[@"color"];
            [themes addObject:tempTheme];
        }
        // send update signal
        [(RACSubject *)self.updateTableSignal sendNext:nil];
    }];
}

@end
