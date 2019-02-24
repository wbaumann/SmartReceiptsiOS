//
//  DatabaseMigration.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseMigration.h"
#import "Constants.h"
#import "DatabaseCreateAtVersion11.h"
#import "DatabaseUpgradeToVersion12.h"
#import "Database.h"
#import "DatabaseUpgradeToVersion13.h"
#import "Database+Functions.h"
#import "SmartReceipts-Swift.h"

@implementation DatabaseMigration

+ (NSArray *)allMigrations {
    return @[
            [DatabaseCreateAtVersion11 new],
            [DatabaseUpgradeToVersion12 new],
            [DatabaseUpgradeToVersion13 new],
            [DatabaseUpgradeToVersion14 new],
            [DatabaseUpgradeToVersion15 new],
            [DatabaseUpgradeToVersion16 new],
            [DatabaseUpgradeToVersion17 new],
            [DatabaseUpgradeToVersion18 new],
            [DatabaseUpgradeToVersion19 new],
    ];
}

- (NSUInteger)version {
    ABSTRACT_METHOD
    return 0;
}

- (BOOL)migrate:(Database *)database {
    ABSTRACT_METHOD
    return NO;
}

+ (BOOL)migrateDatabase:(Database *)database {
    NSArray *migrations = [self allMigrations];
    return [self runMigrations:migrations onDatabase:database];
}

+ (BOOL)runMigrations:(NSArray *)migrations onDatabase:(Database *)database {
    TICK;
    NSUInteger currentVersion = [database databaseVersion];
    LOGGER_INFO(@"Current version: %tu", currentVersion);

    for (DatabaseMigration *migration in migrations) {
        if (currentVersion >= migration.version) {
            LOGGER_INFO(@"DB at version %tu, will skip migration to %tu", currentVersion, migration.version);
            continue;
        }

        LOGGER_INFO(@"Migrate to version %tu", migration.version);
        if (![migration migrate:database]) {
            LOGGER_ERROR(@"Failed on migration %tu", migration.version);
            [[AnalyticsManager sharedManager] recordWithEvent:[Event failedDatabaseMigration:migration.version]];
            return NO;
        }

        currentVersion = migration.version;
        [database setDatabaseVersion:currentVersion];
    }
    
    LOGGER_DEBUG(@"Migration time %@", TOCK);
    
    return YES;
}

@end
