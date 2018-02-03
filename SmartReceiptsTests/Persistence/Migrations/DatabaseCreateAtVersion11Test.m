//
//  DatabaseCreateAtVersion11Test.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseMigration.h"
#import "DatabaseCreateAtVersion11.h"
#import "FMDatabaseAdditions.h"
#import "SmartReceiptsTestsBase.h"
#import "Database.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "DatabaseTestsHelper.h"

@interface DatabaseMigration (TestExpose)

+ (BOOL)runMigrations:(NSArray *)migrations onDatabase:(Database *)database;

@end

@interface DatabaseCreateAtVersion11Test : SmartReceiptsTestsBase

@end

@implementation DatabaseCreateAtVersion11Test

- (void)setUp {
    [super setUp];

    [self deleteTestDatabase];

    self.db = [self createAndOpenDatabaseWithPath:self.testDBPath migrated:NO];
    DatabaseMigration *migration = [[DatabaseCreateAtVersion11 alloc] init];
    [DatabaseMigration runMigrations:@[migration] onDatabase:self.db];
}

- (void)testSameStructureDatabaseWasGenerated {
    [self checkDatabasesSame:[[NSBundle bundleForClass:[self class]] pathForResource:@"receipts_at_v11" ofType:@"db"] checked:self.testDBPath];
}

- (void)testDefaultValuesAddedForCategories {
    XCTAssertEqual(25, [self.db countRowsInTable:CategoriesTable.TABLE_NAME], @"Default categories not entered");
}

- (void)testDefaultValuesAddedForCSVColumns {
    XCTAssertEqual(8, [self.db countRowsInTable:CSVTable.TABLE_NAME], @"Default CSV columns not entered");
}

- (void)testDefaultValuesAddedForPDFColumns {
    XCTAssertEqual(6, [self.db countRowsInTable:PDFTable.TABLE_NAME], @"Default PDF columns not entered");
}

- (void)testCompareWithAndroidVersionAt11 {
    [self checkDatabasesSame:[[NSBundle bundleForClass:[self class]] pathForResource:@"android-receipts-v11" ofType:@"db"] checked:self.testDBPath];
}

@end
