//
//  PassValueDelegate.h
//  Memo
//
//  Created by Richard on 16/7/24.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XGGPassValueDelegate <NSObject>

- (void)passValue: (NSDictionary *)info;

@end

