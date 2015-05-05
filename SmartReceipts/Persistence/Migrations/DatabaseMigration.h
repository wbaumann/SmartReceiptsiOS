//
//  DatabaseMigration.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@class Database;

@interface DatabaseMigration : NSObject

+ (NSArray *)allMigrations;
+ (BOOL)migrateDatabase:(Database *)database;

- (NSUInteger)version;
- (BOOL)migrate:(Database *)database;

@end
