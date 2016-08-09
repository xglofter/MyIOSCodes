//
//  ZHDMainViewModel.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/2.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface ZHDMainViewModel : RVMViewModel

@property(nonatomic, strong) RACSignal *updateTableSignal;

- (instancetype)initWithModel:(id)model;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)titleForSection:(NSInteger)section;
- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subTitleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)imageURLAtIndexPath:(NSIndexPath *)indexPath;

@end
