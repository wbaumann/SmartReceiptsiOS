//
//  DatabaseHintsTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "Database+Hints.h"

@interface DatabaseHintsTest : SmartReceiptsTestsBase

@end

@implementation DatabaseHintsTest

- (void)setUp {
    [super setUp];

    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME : @"Trip one"}];
    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME : @"Trip two"}];
    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME : @"Trip three"}]; // will be the first in the array

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"Receipt one"}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"Receipt two"}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"Receipt three"}]; // will be the first in the array
}

#pragma mark - tests

- (void)testTripHintGotten {
    NSArray *hints = [self.db hintForTripBasedOnEntry:@"Trip tw"];
    NSString *firstHint = hints.firstObject;
    XCTAssertEqual(hints.count, 1, "count was not 1");
    XCTAssertTrue([firstHint isEqualToString:@"Trip two"], "wrong trip gotten");
}

- (void)testTripTwoHintsGotten {
    NSArray *hints = [self.db hintForTripBasedOnEntry:@"Trip t"];
    NSString *firstHint = hints.firstObject;
    XCTAssertEqual(hints.count, 2, "count was not 2");
    XCTAssertTrue([firstHint isEqualToString:@"Trip three"], "wrong trip gotten");
}

- (void)testNoTripHintGotten {
    NSArray *hints = [self.db hintForTripBasedOnEntry:@"XYX"];
    XCTAssertEqual(hints.count, 0, "count was not 0");
}

#pragma mark -

- (void)testReceiptHintGotten {
    NSArray *hints = [self.db hintForReceiptBasedOnEntry:@"Receipt tw"];
    NSString *firstHint = hints.firstObject;
    XCTAssertEqual(hints.count, 1, "count was not 1");
    XCTAssertTrue([firstHint isEqualToString:@"Receipt two"], "wrong receipt gotten");
}

- (void)testReceiptTwoHintsGotten {
    NSArray *hints = [self.db hintForReceiptBasedOnEntry:@"Receipt t"];
    NSString *firstHint = hints.firstObject;
    XCTAssertEqual(hints.count, 2, "count was not 2");
    XCTAssertTrue([firstHint isEqualToString:@"Receipt three"], "wrong receipt gotten");
}

- (void)testNoReceiptHintGotten {
    NSArray *hints = [self.db hintForReceiptBasedOnEntry:@"XYX"];
    XCTAssertEqual(hints.count, 0, "count was not 0");
}

@end
