//
//  Note+CoreDataProperties.h
//  Memo
//
//  Created by Richard on 16/7/24.
//  Copyright © 2016年 Richard. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *time;

@end

NS_ASSUME_NONNULL_END
