//
//  DatabaseCreateAtVersion11.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseCreateAtVersion11.h"
#import "WBDB.h"

@interface WBDB (Expose)

+ (BOOL)setupAndroidDatabaseVersionInQueue:(FMDatabaseQueue *)queue;
+ (BOOL)setupAndroidMetadataTableInQueue:(FMDatabaseQueue *)queue;

@end

@interface WBTripsHelper (Expose)

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue;

@end

@interface WBReceiptsHelper (Expose)

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue;

@end

@interface WBCategoriesHelper (Expose)

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue;

@end

@interface WBColumnsHelper (Expose)

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue withTableName:(NSString *)tableName;

@end

@implementation DatabaseCreateAtVersion11

- (NSUInteger)version {
    return 11;
}

- (BOOL)migrate:(FMDatabaseQueue *)databaseQueue {
    return [WBDB setupAndroidDatabaseVersionInQueue:databaseQueue]
            && [WBDB setupAndroidMetadataTableInQueue:databaseQueue]
            && [WBTripsHelper createTableInQueue:databaseQueue]
            && [WBReceiptsHelper createTableInQueue:databaseQueue]
            && [WBCategoriesHelper createTableInQueue:databaseQueue]
            && [WBColumnsHelper createTableInQueue:databaseQueue withTableName:[WBColumnsHelper TABLE_NAME_CSV]]
            && [WBColumnsHelper createTableInQueue:databaseQueue withTableName:[WBColumnsHelper TABLE_NAME_PDF]];
}

@end
