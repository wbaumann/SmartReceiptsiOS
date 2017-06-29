//
//  DatabaseReceiptsPaymentMethodTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 15/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "Database+PaymentMethods.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "WBReceipt.h"

@interface DatabaseReceiptsPaymentMethodTest : SmartReceiptsTestsBase

@end

@implementation DatabaseReceiptsPaymentMethodTest

- (void)testReceiptPaymentMethodSaved {
    PaymentMethod *method = [[self.db allPaymentMethods] firstObject];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PAYMENT_METHOD_ID : method, ReceiptsTable.COLUMN_NAME : @"ReceiptXYZ"}];

    WBReceipt *receipt = [self.db receiptWithName:@"ReceiptXYZ"];
    XCTAssertNotNil(receipt);
    XCTAssertEqualObjects(receipt.paymentMethod, method);
}

@end
