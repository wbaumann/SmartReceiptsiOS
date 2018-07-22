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
#import <SmartReceipts-Swift.h>
#import "Database+Trips.h"

@interface Database (Expose)

- (WBTrip *)tripWithName:(NSString *)name;

@end

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
    Price *testPrice = [[Price alloc] initWithAmount:[NSDecimalNumber decimalNumberOrZero:@"10"] currencyCode:@"USD"];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : receiptName, ReceiptsTable.COLUMN_PRICE : testPrice.amount}];

    WBReceipt *receipt = [self.db receiptWithName:receiptName];

    UIImage *receiptImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sample-receipt" ofType:@"jpg"]];
    [self.db.filesManager saveImage:receiptImage forReceipt:receipt];

    WBTrip *trip = receipt.trip;
    XCTAssertEqualObjects(testPrice.currencyFormattedPrice, trip.formattedPrice);

    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db deleteReceipt:receipt];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];

    XCTAssertEqual(countBefore - 1, countAfter);

    XCTAssertFalse([self.db.filesManager fileExistsForReceipt:receipt]);

    WBTrip *reloaded = [self.db tripWithName:receipt.trip.name];
    XCTAssertEqualObjects(@"$0.00", reloaded.formattedPrice);
}

@end
