//
//  DatabaseMigration.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

@interface DatabaseMigration : NSObject

+ (instancetype)createDBMigration;
+ (NSArray *)upgradeMigrations;
+ (BOOL)migrateDatabase:(FMDatabaseQueue *)databaseQueue;

- (NSUInteger)version;
- (void)migrate:(FMDatabaseQueue *)databaseQueue;

@end
