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

@interface DatabaseReceiptsSumTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseReceiptsSumTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTrip:@{}];
}

- (void)testSumReceipts {
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"10"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"15"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"12"]}];

    NSDecimalNumber *sumOfReceipts = [self.db sumOfReceiptsForTrip:self.trip];
    NSDecimalNumber *expected = [NSDecimalNumber decimalNumberWithString:@"37"];
    XCTAssertEqualObjects(expected, sumOfReceipts);
}

@end
