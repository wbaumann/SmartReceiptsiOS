//
//  DatabaseReceiptsTest.m
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
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "WBReceipt.h"
#import "Database+Receipts.h"
#import "Database+PaymentMethods.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "WBPrice.h"
#import "Database+Trips.h"

@interface DatabaseReceiptsTest : SmartReceiptsTestsBase

@end

@implementation DatabaseReceiptsTest



- (void)testReceiptSaved {
    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db insertTestReceipt:@{}];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    XCTAssertEqual(countBefore + 1, countAfter);
}

- (void)testReceiptUpdated {
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : @"TestXYZ"}];
    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];

    WBReceipt *receipt = [self.db receiptWithName:@"TestXYZ"];
    XCTAssertNotNil(receipt);
    NSString *testName = @"AlteredXZZZ";
    receipt.name = testName;
    PaymentMethod *testMethod = [[self.db allPaymentMethods] firstObject];
    receipt.paymentMethod = testMethod;
    [self.db saveReceipt:receipt];

    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    XCTAssertEqual(countBefore, countAfter);
    
    WBReceipt *loaded = [self.db receiptWithName:testName];
    XCTAssertNotNil(loaded);
    XCTAssertEqualObjects(testMethod, loaded.paymentMethod);
}

- (void)testReceiptDeleted {
    NSString *receiptName = @"Unique12345678";
    NSDecimalNumber *testPrice = [NSDecimalNumber decimalNumberOrZero:@"10"];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : receiptName, ReceiptsTable.COLUMN_PRICE : testPrice}];

    WBReceipt *receipt = [self.db receiptWithName:receiptName];

    UIImage *receiptImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sample-receipt" ofType:@"jpg"]];
    [self.db.filesManager saveImage:receiptImage forReceipt:receipt];

    WBTrip *trip = receipt.trip;
    XCTAssertEqualObjects(testPrice, trip.price.amount);

    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db deleteReceipt:receipt];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];

    XCTAssertEqual(countBefore - 1, countAfter);

    XCTAssertFalse([self.db.filesManager fileExistsForReceipt:receipt]);

    WBTrip *reloaded = [self.db tripWithName:receipt.trip.name];
    XCTAssertEqualObjects([NSDecimalNumber zero], reloaded.price.amount);
}

@end
