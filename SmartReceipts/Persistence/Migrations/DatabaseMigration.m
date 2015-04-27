//
//  DatabaseMigration.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseMigration.h"
#import "Constants.h"
#import "DatabaseCreateAtVersion11.h"
#import "DatabaseUpgradeToVersion12.h"
#import "FMDatabaseAdditions.h"

@implementation DatabaseMigration


+ (instancetype)createDBMigration {
    return [[DatabaseCreateAtVersion11 alloc] init];
}

+ (NSArray *)upgradeMigrations {
    return @[
            [[DatabaseUpgradeToVersion12 alloc] init],
            [[DatabaseUpgradeToVersion12 alloc] init]
    ];
}

- (NSUInteger)version {
    ABSTRACT_METHOD
    return 0;
}

- (void)migrate:(FMDatabaseQueue *)databaseQueue {
    ABSTRACT_METHOD
}

+ (BOOL)migrateDatabase:(FMDatabaseQueue *)databaseQueue {
    NSInteger currentVersion = [self databaseVersion:databaseQueue];
    NSLog(@"Current version: %d", currentVersion);

    return NO;
}

+ (NSInteger)databaseVersion:(FMDatabaseQueue *)databaseQueue {
    __block NSInteger version = 0;
    [databaseQueue inDatabase:^(FMDatabase *db) {
        version = [db intForQuery:@"PRAGMA user_version"];
    }];
    return version;
}

@end
