//
//  DatabaseMigrationTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseTestsBase.h"
#import "FMDatabaseQueue+QueueShortcuts.h"
#import "DatabaseMigration.h"

@interface DatabaseMigrationTest : DatabaseTestsBase

@property (nonatomic, copy) NSString *referenceDBPath;

@end

@implementation DatabaseMigrationTest

- (void)setUp {
    self.testDBPath = [self generateTestDBPath];
    self.referenceDBPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"receipts_at_v11" ofType:@"db"];
}

- (void)tearDown {
    [[NSFileManager defaultManager] removeItemAtPath:self.testDBPath error:nil];
}

- (void)testCreatedDatabaseMigratedToVersion13 {
    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.testDBPath];
    XCTAssertEqual(0, databaseQueue.databaseVersion);
    BOOL migrationSuccess = [DatabaseMigration migrateDatabase:databaseQueue];
    XCTAssertTrue(migrationSuccess);

    XCTAssertEqual(13, databaseQueue.databaseVersion);

    //TODO jaanus: check also against reference db at version 13
}

- (void)testReferenceDatabaseMigratedFromVersion11ToVersion13 {
    NSError *copyError = nil;
    [[NSFileManager defaultManager] copyItemAtPath:self.referenceDBPath toPath:self.testDBPath error:&copyError];
    XCTAssertNil(copyError);

    FMDatabaseQueue *databaseQueue = [FMDatabaseQueue databaseQueueWithPath:self.testDBPath];
    XCTAssertEqual(11, databaseQueue.databaseVersion);
    BOOL migrationSuccess = [DatabaseMigration migrateDatabase:databaseQueue];
    XCTAssertTrue(migrationSuccess);

    XCTAssertEqual(13, databaseQueue.databaseVersion);

    //TODO jaanus: check also against reference db at version 13
}

@end
