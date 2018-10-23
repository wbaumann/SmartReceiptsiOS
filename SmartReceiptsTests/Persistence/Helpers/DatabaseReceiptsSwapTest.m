//
//  DatabaseReceiptsSwapTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 21/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBReceipt.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "NSDate+Calculations.h"
#import "Database+Receipts.h"
#import "FetchedModelAdapter.h"

@interface FetchedModelAdapter (TestExpose)

- (void)clearNotificationListener;

@end

@interface DatabaseReceiptsSwapTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *testTrip;
@property (nonatomic, strong) WBReceipt *one;
@property (nonatomic, strong) WBReceipt *two;

@end

@implementation DatabaseReceiptsSwapTest

- (void)setUp {
    [super setUp];

    self.testTrip = [self.db createTestTrip];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.testTrip, ReceiptsTable.COLUMN_DATE : [[NSDate date] dateByAddingDays:-2]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.testTrip, ReceiptsTable.COLUMN_DATE : [[NSDate date] dateByAddingDays:-1]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"TEST 1", ReceiptsTable.COLUMN_PARENT_ID : self.testTrip, ReceiptsTable.COLUMN_DATE : [NSDate date]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"TEST 2", ReceiptsTable.COLUMN_PARENT_ID : self.testTrip, ReceiptsTable.COLUMN_DATE : [NSDate date]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.testTrip}];

    self.one = [self.db receiptWithName:@"TEST 1"];
    self.two = [self.db receiptWithName:@"TEST 2"];
}

- (void)testReceiptsSwap {
    FetchedModelAdapter *adapter = [self.db fetchedReceiptsAdapterForTrip:self.testTrip];
    [adapter clearNotificationListener];

    NSUInteger indexOne = [adapter indexForObject:self.one];
    NSDate *dateOne = self.one.date;

    NSUInteger indexTwo = [adapter indexForObject:self.two];
    NSDate *dateTwo = self.two.date;

    [self.db swapReceipt:self.one withReceipt:self.two];

    [adapter fetch];

    XCTAssertEqual(indexOne, [adapter indexForObject:self.two]);
    XCTAssertEqual(indexTwo, [adapter indexForObject:self.one]);

    WBReceipt *fetchedOne = [self.db receiptWithName:self.one.name];
    XCTAssertEqualObjects(dateTwo, fetchedOne.date);

    WBReceipt *fetchedTwo = [self.db receiptWithName:self.two.name];
    XCTAssertEqualObjects(dateOne, fetchedTwo.date);
}

@end
