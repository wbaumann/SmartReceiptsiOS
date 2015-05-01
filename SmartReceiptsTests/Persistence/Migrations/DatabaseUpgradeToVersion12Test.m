//
//  DatabaseUpgradeToVersion12Test.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "Database.h"
#import "DatabaseCreateAtVersion11.h"
#import "DatabaseUpgradeToVersion12.h"
#import "DatabaseTableNames.h"

@interface DatabaseUpgradeToVersion12Test : DatabaseTestsBase

@end

@implementation DatabaseUpgradeToVersion12Test

- (void)setUp {
    [super setUp];

    [[[DatabaseCreateAtVersion11 alloc] init] migrate:self.db];
    [[[DatabaseUpgradeToVersion12 alloc] init] migrate:self.db];
}

- (void)testDefaultPaymentMethodsAddedByMigration {
    XCTAssertEqual(5, [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME]);
}

@end
