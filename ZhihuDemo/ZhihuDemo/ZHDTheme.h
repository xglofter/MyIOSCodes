//
//  ZHDTheme.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/11.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

//NS_ASSUME_NONNULL_BEGIN

@interface ZHDTheme : NSObject

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *descrip;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *color;

// Insert code here to declare functionality of your managed object subclass

@end

//NS_ASSUME_NONNULL_END

//#import "ZHDTheme+CoreDataProperties.h"
