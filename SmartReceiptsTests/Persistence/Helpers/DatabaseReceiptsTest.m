//
//  DatabaseReceiptsTest.m
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
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "WBReceipt.h"
#import "Database+Receipts.h"
#import "Database+PaymentMethods.h"

@interface DatabaseReceiptsTest : DatabaseTestsBase

@end

@implementation DatabaseReceiptsTest

- (void)testReceiptSaved {
    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db insertReceipt:@{}];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    XCTAssertEqual(countBefore + 1, countAfter);
}

- (void)testReceiptUpdated {
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_NAME: @"TestXYZ"}];
    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];

    WBReceipt *receipt = [self.db receiptWithName:@"TestXYZ"];
    XCTAssertNotNil(receipt);
    NSString *testName = @"AlteredXZZZ";
    receipt.name = testName;
    PaymentMethod *testMethod = [[self.db allPaymentMethods] firstObject];
    receipt.paymentMethod = testMethod;
    [self.db updateReceipt:receipt];

    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    XCTAssertEqual(countBefore, countAfter);
    
    WBReceipt *loaded = [self.db receiptWithName:testName];
    XCTAssertNotNil(loaded);
    XCTAssertEqualObjects(testMethod, loaded.paymentMethod);

}

@end
