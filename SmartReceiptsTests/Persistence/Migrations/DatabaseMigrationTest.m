//
//  DatabaseMigrationTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "DatabaseMigration.h"
#import "Database.h"
#import "Database+Functions.h"
#import "DatabaseTestsHelper.h"

@interface DatabaseMigrationTest : SmartReceiptsTestsBase

@property (nonatomic, copy) NSString *referenceDBPath;

@end

@implementation DatabaseMigrationTest

- (void)setUp {
    [super setUp];

    self.referenceDBPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"receipts_at_v11" ofType:@"db"];
}

- (void)testCreatedDatabaseMigratedToVersion13 {
    [self deleteTestDatabase];

    DatabaseTestsHelper *database = [self createAndOpenUnmigratedDatabaseWithPath:self.testDBPath];
    XCTAssertEqual(0, database.databaseVersion);
    BOOL migrationSuccess = [DatabaseMigration migrateDatabase:database];
    XCTAssertTrue(migrationSuccess);

    XCTAssertEqual(13, database.databaseVersion);

    //TODO jaanus: check also against reference db at version 13
}

- (void)testReferenceDatabaseMigratedFromVersion11ToVersion13 {
    [self deleteTestDatabase];

    NSError *copyError = nil;
    [[NSFileManager defaultManager] copyItemAtPath:self.referenceDBPath toPath:self.testDBPath error:&copyError];
    XCTAssertNil(copyError);

    DatabaseTestsHelper *database = [self createAndOpenUnmigratedDatabaseWithPath:self.testDBPath];
    XCTAssertEqual(11, database.databaseVersion);
    BOOL migrationSuccess = [DatabaseMigration migrateDatabase:database];
    XCTAssertTrue(migrationSuccess);

    XCTAssertEqual(13, database.databaseVersion);

    //TODO jaanus: check also against reference db at version 13
}

@end
