//
//  DatabaseQueryBuilderTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseQueryBuilder.h"
#import "DatabaseTableNames.h"

@interface DatabaseQueryBuilderTest : XCTestCase

@end

@implementation DatabaseQueryBuilderTest

- (void)testInsertQueryBuild {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder insertStatementForTable:@"testing_query"];
    [statement addParam:@"one" value:@1];
    [statement addParam:@"three" value:@"long"];
    [statement addParam:@"two" value:@"pretty"];

    NSString *query = [statement buildStatement];
    NSString *expected = @"INSERT INTO testing_query (one, three, two) VALUES (:one, :three, :two)";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@1, params[@"one"]);
    XCTAssertEqual(@"long", params[@"three"]);
    XCTAssertEqual(@"pretty", params[@"two"]);
}

- (void)testDeleteQueryBuild {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder deleteStatementForTable:@"testing_delete"];
    [statement where:@"id" value:@12];

    NSString *query = [statement buildStatement];
    NSString *expected = @"DELETE FROM testing_delete WHERE id = :id";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@12, params[@"id"]);
}

- (void)testUpdateQueryBuild {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder updateStatementForTable:@"testing_update"];
    [statement addParam:@"one" value:@1];
    [statement addParam:@"three" value:@"long"];
    [statement addParam:@"two" value:@"pretty"];
    [statement where:@"id" value:@12];

    NSString *query = [statement buildStatement];
    NSString *expected = @"UPDATE testing_update SET one = :one, three = :three, two = :two WHERE id = :id";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@12, params[@"id"]);
}

- (void)testSumQueryBuilder {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder sumStatementForTable:@"testing_sum"];
    [statement setSumColumn:@"amount"];
    [statement where:@"cake" value:@"brown"];

    NSString *query = [statement buildStatement];
    NSString *expected = @"SELECT SUM(amount) FROM testing_sum WHERE cake = :cake";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@"brown", params[@"cake"]);
}

- (void)testSumMultiWhereClauses {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder sumStatementForTable:@"testing_sum"];
    [statement setSumColumn:@"amount"];
    [statement where:@"cake" value:@"brown"];
    [statement where:@"baked" value:@"good"];

    NSString *query = [statement buildStatement];
    NSString *expected = @"SELECT SUM(amount) FROM testing_sum WHERE baked = :baked AND cake = :cake";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@"brown", params[@"cake"]);
    XCTAssertEqual(@"good", params[@"baked"]);
}

- (void)testOddSumQueryBuilder {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder sumStatementForTable:@"testing_sum"];
    //TODO jaanus: this may need rethinking
    [statement setSumColumn:@"distance * rate"];
    [statement where:@"cake" value:@"brown"];

    NSString *query = [statement buildStatement];
    NSString *expected = @"SELECT SUM(distance * rate) FROM testing_sum WHERE cake = :cake";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@"brown", params[@"cake"]);
}

- (void)testSelectAllQueryBuild {
    DatabaseQueryBuilder *statement = [DatabaseQueryBuilder selectAllStatementForTable:@"testing_select_all"];
    [statement where:@"id" value:@12];

    NSString *query = [statement buildStatement];
    NSString *expected = @"SELECT * FROM testing_select_all WHERE id = :id";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [statement parameters];
    XCTAssertEqual(@12, params[@"id"]);
}

- (void)testSelectAllAndOrderBy {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:ReceiptsTable.TABLE_NAME];
    [select orderBy:ReceiptsTable.COLUMN_DATE ascending:YES];

    NSString *query = [select buildStatement];
    NSString *expected = @"SELECT * FROM receipts ORDER BY rcpt_date ASC";
    XCTAssertEqualObjects(expected, query, @"Got %@", query);

    NSDictionary *params = [select parameters];
    XCTAssertEqual(0, params.count);
}

@end
