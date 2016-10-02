//
//  ZHDDetailViewModel.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/10.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface ZHDDetailViewModel : RVMViewModel

@property(nonatomic, strong) RACSignal *updateTableSignal;

- (instancetype)initWithModel:(id)model;

@end
