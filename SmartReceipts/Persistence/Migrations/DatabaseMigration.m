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

- (BOOL)migrate:(Database *)database {
    ABSTRACT_METHOD
    return NO;
}

+ (BOOL)migrateDatabase:(Database *)database {
    NSArray *migrations = [self allMigrations];
    return [self runMigrations:migrations onDatabase:database];
}

+ (BOOL)runMigrations:(NSArray *)migrations onDatabase:(Database *)database {
    NSUInteger currentVersion = [database databaseVersion];
    SRLog(@"Current version: %tu", currentVersion);

    for (DatabaseMigration *migration in migrations) {
        if (currentVersion >= migration.version) {
            SRLog(@"DB at version %tu, will skip migration to %tu", currentVersion, migration.version);
            continue;
        }

        SRLog(@"Migrate to version %tu", migration.version);
        if (![migration migrate:database]) {
            SRLog(@"Failed on migration %tu", migration.version);
            return NO;
        }

        currentVersion = migration.version;
        [database setDatabaseVersion:currentVersion];
    }

    return YES;
}

@end
