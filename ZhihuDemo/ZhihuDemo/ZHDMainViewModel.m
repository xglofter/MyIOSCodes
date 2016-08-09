//
//  ZHDMainViewModel.m
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "ZHDMainViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation ZHDMainViewModel


- (instancetype)initWithModel:(id)model {

    self.updateTableSignal = [[RACSubject subject] setNameWithFormat:@"ZHDMainViewModel updateTableSignal"];

    return self;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (NSString *)titleForSection:(NSInteger)section {
    return @"section title name";
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    return @"title name";
}

- (NSString *)subTitleAtIndexPath:(NSIndexPath *)indexPath {
    return @"subtitle name";
}

- (NSString *)imageURLAtIndexPath:(NSIndexPath *)indexPath {
    return @"";
}


#pragma mark Private Methods

// TODO: update the tableView's data
// use [(RACSubject *)self.updateTableSignal sendNext:nil]

@end
