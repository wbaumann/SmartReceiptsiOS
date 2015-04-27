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

@interface DatabaseCreateAtVersion11Test : XCTestCase

@property (nonatomic, copy) NSString *testDBPath;
@property (nonatomic, strong) FMDatabaseQueue *db;

@end

@implementation DatabaseCreateAtVersion11Test

- (NSString *)generateTestDBPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"test_db_%d", (int) [NSDate timeIntervalSinceReferenceDate]]];
}

- (void)setUp {
    self.testDBPath = [self generateTestDBPath];
    self.db = [FMDatabaseQueue databaseQueueWithPath:self.testDBPath];
}

- (void)tearDown {
    [[NSFileManager defaultManager] removeItemAtPath:self.testDBPath error:nil];
}

- (void)testSameStructureDatabaseWasGenerated {
    DatabaseMigration *migration = [[DatabaseCreateAtVersion11 alloc] init];
    [migration migrate:self.db];
    [self checkDatabasesSame:[[NSBundle bundleForClass:[self class]] pathForResource:@"receipts_at_v11" ofType:@"db"] checked:self.testDBPath];
}

- (void)checkDatabasesSame:(NSString *)pathToReferenceDB checked:(NSString *)pathToCheckedDB {
    XCTAssertTrue(([[NSFileManager defaultManager] fileExistsAtPath:pathToReferenceDB]));
    XCTAssertTrue(([[NSFileManager defaultManager] fileExistsAtPath:pathToCheckedDB]));

    FMDatabaseQueue *referenceDB = [FMDatabaseQueue databaseQueueWithPath:pathToReferenceDB];
    FMDatabaseQueue *checkedDB = [FMDatabaseQueue databaseQueueWithPath:pathToCheckedDB];
    XCTAssertNotNil(referenceDB);
    XCTAssertNotNil(checkedDB);

    XCTAssertEqual([self databaseVersion:referenceDB], [self databaseVersion:checkedDB]);

    NSArray *tablesInReference = [self tableNames:referenceDB];
    NSArray *tablesInChecked = [self tableNames:checkedDB];
    XCTAssertEqual(tablesInReference.count, tablesInChecked.count);
    XCTAssertTrue([tablesInReference isEqualToArray:tablesInChecked]);
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

- (NSUInteger)databaseVersion:(FMDatabaseQueue *)database {
    __block NSUInteger version = 0;
    [database inDatabase:^(FMDatabase *db) {
        version = (NSUInteger) [db intForQuery:@"PRAGMA user_version"];
    }];
    return version;
}

@end
