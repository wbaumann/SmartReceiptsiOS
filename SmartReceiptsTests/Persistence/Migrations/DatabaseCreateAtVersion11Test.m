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
#import "DatabaseTestsBase.h"
#import "Database.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"

@interface DatabaseMigration (TestExpose)

+ (BOOL)runMigrations:(NSArray *)migrations onDatabase:(Database *)database;

@end

@interface DatabaseCreateAtVersion11Test : DatabaseTestsBase

@end

@implementation DatabaseCreateAtVersion11Test

- (void)setUp {
    [super setUp];
    DatabaseMigration *migration = [[DatabaseCreateAtVersion11 alloc] init];
    [DatabaseMigration runMigrations:@[migration] onDatabase:self.db];
}

- (void)testSameStructureDatabaseWasGenerated {
    [self checkDatabasesSame:[[NSBundle bundleForClass:[self class]] pathForResource:@"receipts_at_v11" ofType:@"db"] checked:self.testDBPath];
}

- (void)testDefaultValuesAddedForCategories {
    XCTAssertEqual(24, [self.db countRowsInTable:CategoriesTable.TABLE_NAME], @"Default categories not entered");
}

- (void)testDefaultValuesAddedForCSVColumns {
    XCTAssertEqual(5, [self.db countRowsInTable:CSVTable.TABLE_NAME], @"Default CSV columns not entered");
}

- (void)testDefaultValuesAddedForPDFColumns {
    XCTAssertEqual(6, [self.db countRowsInTable:PDFTable.TABLE_NAME], @"Default PDF columns not entered");
}

- (void)checkDatabasesSame:(NSString *)pathToReferenceDB checked:(NSString *)pathToCheckedDB {
    XCTAssertTrue(([[NSFileManager defaultManager] fileExistsAtPath:pathToReferenceDB]));
    XCTAssertTrue(([[NSFileManager defaultManager] fileExistsAtPath:pathToCheckedDB]));

    Database *referenceDB = [self createAndOpenDatabaseWithPath:pathToReferenceDB];
    Database *checkedDB = [self createAndOpenDatabaseWithPath:pathToCheckedDB];
    XCTAssertNotNil(referenceDB);
    XCTAssertNotNil(checkedDB);

    XCTAssertEqual([referenceDB databaseVersion], [checkedDB databaseVersion]);

    NSArray *tablesInReference = [self tableNames:referenceDB.databaseQueue];
    NSArray *tablesInChecked = [self tableNames:checkedDB.databaseQueue];
    XCTAssertEqual(tablesInReference.count, tablesInChecked.count);
    XCTAssertTrue([tablesInReference isEqualToArray:tablesInChecked]);

    for (NSString *tableName in tablesInReference) {
        NSArray *tableColumnsInReference = [self columnsInTableNamed:tableName inDatabase:referenceDB.databaseQueue];
        NSArray *tableColumnsInChecked = [self columnsInTableNamed:tableName inDatabase:referenceDB.databaseQueue];
        XCTAssertTrue([tableColumnsInReference isEqualToArray:tableColumnsInChecked]);
    }
}

- (NSArray *)columnsInTableNamed:(NSString *)name inDatabase:(FMDatabaseQueue *)database {
    __block NSMutableArray *columns = [NSMutableArray array];
    [database inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"PRAGMA table_info('%@')", name]];
        while ([resultSet next]) {
            [columns addObject:[resultSet stringForColumnIndex:1]];
        }
    }];
    return [columns sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)tableNames:(FMDatabaseQueue *)database {
    __block NSMutableArray *tables = [NSMutableArray array];
    [database inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"];
        while ([resultSet next]) {
            [tables addObject:[resultSet stringForColumnIndex:0]];
        }
    }];
    return [tables sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end
