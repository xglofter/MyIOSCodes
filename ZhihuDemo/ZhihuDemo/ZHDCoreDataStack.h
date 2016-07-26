//
//  ZHDCoreDataStack.h
//  ZhihuDemo
//
//  Created by guang xu on 16/7/26.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ZHDCoreDataStack : NSObject

+ (instancetype)defaultStack;
//+ (instancetype)inMemoryStack; // ???

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)ensureInitialLoad;

@end
