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

@end
