//
//  ZHDTheme+CoreDataProperties.h
//  ZhihuDemo
//
//  Created by Richard on 16/8/11.
//  Copyright © 2016年 Richard. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ZHDTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHDTheme (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *descrip;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *color;

@end

NS_ASSUME_NONNULL_END
