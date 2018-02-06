//
//  DatabaseReceiptEditTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 21/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "NSDate+Calculations.h"
#import "WBReceipt.h"
#import "Database+Receipts.h"
#import "Constants.h"
#import "Database+Trips.h"

@interface DatabaseReceiptEditTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBReceipt *testReceipt;

@end

@implementation DatabaseReceiptEditTest

- (void)setUp {
    [super setUp];

    WBTrip *trip = [self.db createTestTrip];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}]; // seconds 1
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}]; // seconds 2
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}]; // seconds 3

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: trip, ReceiptsTable.COLUMN_NAME: @"TEST NAME", ReceiptsTable.COLUMN_DATE: [[NSDate date] dateByAddingDays:-1]}];
    self.testReceipt = [self.db receiptWithName:@"TEST NAME"];
}

- (void)testReceiptMoveToAnotherDate {
    NSDate *date = [NSDate date];
    [self.testReceipt setDate:date];

    [self.db saveReceipt:self.testReceipt];

    WBReceipt *fetched = [self.db receiptWithName:self.testReceipt.name];
    XCTAssertTrue([[[date dateByAddingTimeInterval:1] description] isEqualToString:fetched.date.description]);
}

@end
