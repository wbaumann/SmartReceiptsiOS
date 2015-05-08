//
//  DatabaseReceiptsSumTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database+Receipts.h"

@interface Database (TestExpose)

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip onlyExpenseableReceipts:(BOOL)onlyExpenseable;

@end

@interface DatabaseReceiptsSumTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseReceiptsSumTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTrip:@{}];
}

- (void)testSumReceipts {
    [self createTestReceipts];

    NSDecimalNumber *sumOfReceipts = [self.db sumOfReceiptsForTrip:self.trip onlyExpenseableReceipts:NO];
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberWithString:@"37"];
    XCTAssertEqualObjects(expected, sumOfReceipts);
}

- (void)testSumWithNonExpenseableExcluded {
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT : self.trip,
            ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"200"],
            ReceiptsTable.COLUMN_EXPENSEABLE : @(NO)}];
    [self createTestReceipts];

    NSDecimalNumber *sumOfReceipts = [self.db sumOfReceiptsForTrip:self.trip onlyExpenseableReceipts:YES];
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberWithString:@"37"];
    XCTAssertEqualObjects(expected, sumOfReceipts);
}

- (void)createTestReceipts {
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"10"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"15"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"12"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"100"]}];
}

@end
