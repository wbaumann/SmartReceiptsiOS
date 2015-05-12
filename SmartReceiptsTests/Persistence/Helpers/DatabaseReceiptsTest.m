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

@interface DatabaseReceiptsTest : DatabaseTestsBase

@end

@implementation DatabaseReceiptsTest

- (void)setUp {
    [super setUp];

    self.db = [self createTestDatabase];
}

- (void)testReceiptSaved {
    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db insertReceipt:@{}];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    XCTAssertEqual(countBefore + 1, countAfter);
}

@end
