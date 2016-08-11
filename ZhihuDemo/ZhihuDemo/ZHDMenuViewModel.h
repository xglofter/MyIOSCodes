//
//  ZHDMenuViewModel.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/11.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface ZHDMenuViewModel : RVMViewModel

@property(nonatomic, strong) RACSignal *updateTableSignal;

- (instancetype)initWithModel:(id)model;

- (NSInteger)numberOfItems;
- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)subTitleAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)imageURLAtIndexPath:(NSIndexPath *)indexPath;

@end
