//
//  XGGListDataSource.h
//  Memo
//
//  Created by Richard on 16/7/16.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock) (id cell, id item);

@interface XGGListDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
      cellIdentifer:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
