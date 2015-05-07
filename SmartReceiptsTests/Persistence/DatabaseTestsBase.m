//
//  DatabaseTestsBase.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseTestsBase.h"
#import "Database.h"
#import "DatabaseTestsHelper.h"
#import "WBPreferencesTestHelper.h"

@interface Database (TestExpose)

- (id)initWithDatabasePath:(NSString *)path;
- (BOOL)open:(BOOL)migrateDatabase;

@end

@interface DatabaseTestsBase ()

@property (nonatomic, strong) WBPreferencesTestHelper *preferencesHelper;

@end

@implementation DatabaseTestsBase

- (NSString *)generateTestDBPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"test_db_%d", (int) [NSDate timeIntervalSinceReferenceDate]]];
}

- (void)setUp {
    self.testDBPath = self.generateTestDBPath;
    [self setDb:[self createAndOpenDatabaseWithPath:self.testDBPath]];

    self.preferencesHelper = [[WBPreferencesTestHelper alloc] init];
    [self.preferencesHelper createPreferencesBackup];
}

- (void)tearDown {
    [self deleteTestDatabase];
    [self.preferencesHelper restorePreferencesBackup];
}

- (void)deleteTestDatabase {
    [self.db close];
    [self setDb:nil];
    [[NSFileManager defaultManager] removeItemAtPath:self.testDBPath error:nil];
}

- (DatabaseTestsHelper *)createAndOpenDatabaseWithPath:(NSString *)path {
    return [self createAndOpenDatabaseWithPath:path migrated:NO];
}

- (DatabaseTestsHelper *)createAndOpenDatabaseWithPath:(NSString *)path migrated:(BOOL)migrated {
    DatabaseTestsHelper *db = [[DatabaseTestsHelper alloc] initWithDatabasePath:path];
    [db open:migrated];
    return db;
}

@end
