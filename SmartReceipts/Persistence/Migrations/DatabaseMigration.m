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
#import "DatabaseUpgradeToVersion13.h"
#import "FMDatabaseQueue+QueueShortcuts.h"

@implementation DatabaseMigration

+ (NSArray *)allMigrations {
    return @[
            [[DatabaseCreateAtVersion11 alloc] init],
            [[DatabaseUpgradeToVersion12 alloc] init],
            [[DatabaseUpgradeToVersion13 alloc] init]
    ];
}

- (NSUInteger)version {
    ABSTRACT_METHOD
    return 0;
}

- (BOOL)migrate:(FMDatabaseQueue *)databaseQueue {
    ABSTRACT_METHOD
    return NO;
}

+ (BOOL)migrateDatabase:(FMDatabaseQueue *)databaseQueue {
    NSUInteger currentVersion = [databaseQueue databaseVersion];
    NSLog(@"Current version: %d", currentVersion);

    NSArray *migrations = [self allMigrations];
    for (DatabaseMigration *migration in migrations) {
        if (currentVersion >= migration.version) {
            SRLog(@"DB at version %d, will skip migration to %d", currentVersion, migration.version);
            continue;
        }

        SRLog(@"Migrate to version %d", migration.version);
        if (![migration migrate:databaseQueue]) {
            SRLog(@"Failed on migration %d", migration.version);
            return NO;
        }

        currentVersion = migration.version;
        [databaseQueue setDatabaseVersion:currentVersion];
    }

    return YES;
}

@end
