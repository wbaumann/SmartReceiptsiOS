//
//  DatabaseReceiptsSumTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database+Receipts.h"

@interface Database (TestExpose)

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip onlyReimbursableReceipts:(BOOL)onlyReimbursable;

@end

@interface DatabaseReceiptsSumTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseReceiptsSumTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTestTrip:@{}];
}

- (void)testSumReceipts {
    [self createTestReceipts];

    NSDecimalNumber *sumOfReceipts = [self.db sumOfReceiptsForTrip:self.trip onlyReimbursableReceipts:NO];
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberWithString:@"37"];
    XCTAssertEqualObjects(expected, sumOfReceipts);
}

- (void)testSumWithNonReimbursableExcluded {
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip,
            ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"200"],
            ReceiptsTable.COLUMN_REIMBURSABLE : @(NO)}];
    [self createTestReceipts];

    NSDecimalNumber *sumOfReceipts = [self.db sumOfReceiptsForTrip:self.trip onlyReimbursableReceipts:YES];
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberWithString:@"37"];
    XCTAssertEqualObjects(expected, sumOfReceipts);
}

- (void)createTestReceipts {
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"10"]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"15"]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"12"]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"100"]}];
}

@end
