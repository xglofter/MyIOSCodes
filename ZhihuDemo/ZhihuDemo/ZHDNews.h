//
//  ZHDNews.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/11.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>

//NS_ASSUME_NONNULL_BEGIN

@interface ZHDNews : NSObject //NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *imageUrl;


@end

//NS_ASSUME_NONNULL_END

//#import "ZHDNews+CoreDataProperties.h"
