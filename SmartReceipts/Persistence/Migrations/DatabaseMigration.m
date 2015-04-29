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
    NSArray *migrations = [self allMigrations];
    return [self runMigrations:migrations onQueue:databaseQueue];
}

+ (BOOL)runMigrations:(NSArray *)migrations onQueue:(FMDatabaseQueue *)queue {
    NSUInteger currentVersion = [queue databaseVersion];
    SRLog(@"Current version: %d", currentVersion);

    for (DatabaseMigration *migration in migrations) {
        if (currentVersion >= migration.version) {
            SRLog(@"DB at version %d, will skip migration to %d", currentVersion, migration.version);
            continue;
        }

        SRLog(@"Migrate to version %d", migration.version);
        if (![migration migrate:queue]) {
            SRLog(@"Failed on migration %d", migration.version);
            return NO;
        }

        currentVersion = migration.version;
        [queue setDatabaseVersion:currentVersion];
    }

    return YES;
}

@end
