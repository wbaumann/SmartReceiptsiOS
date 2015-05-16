//
//  DatabaseHintsTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "Database+Hints.h"

@interface DatabaseHintsTest : DatabaseTestsBase

@end

@implementation DatabaseHintsTest

- (void)setUp {
    [super setUp];

    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME : @"Trip one"}];
    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME : @"Trip two"}];
    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME : @"Trip three"}];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"Receipt one"}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"Receipt two"}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"Receipt three"}];
}

- (void)testTripHintGotten {
    NSString *hint = [self.db hintForTripBasedOnEntry:@"Trip o"];
    XCTAssertNotNil(hint);
    XCTAssertEqualObjects(@"Trip one", hint);
}

- (void)testNoTripHintGotten {
    NSString *hint = [self.db hintForTripBasedOnEntry:@"XYX"];
    XCTAssertNil(hint);
}

- (void)testReceiptHintGotten {
    NSString *hint = [self.db hintForReceiptBasedOnEntry:@"Receipt th"];
    XCTAssertNotNil(hint);
    XCTAssertEqualObjects(@"Receipt three", hint);
}

- (void)testNoReceiptHintGotten {
    NSString *hint = [self.db hintForReceiptBasedOnEntry:@"XYX"];
    XCTAssertNil(hint);
}

@end
