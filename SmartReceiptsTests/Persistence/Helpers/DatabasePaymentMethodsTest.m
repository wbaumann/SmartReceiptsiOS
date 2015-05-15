//
//  DatabasePaymentMethodsTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "DatabaseTestsHelper.h"
#import "Database+PaymentMethods.h"
#import "FetchedModelAdapter.h"
#import "PaymentMethod.h"

@interface Database (TestExpose)

- (PaymentMethod *)methodById:(NSUInteger)methodId;

@end

@interface DatabasePaymentMethodsTest : DatabaseTestsBase

@end

@implementation DatabasePaymentMethodsTest

- (void)testMethodSaved {
    NSUInteger countBefore = [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME];
    [self.db insertPaymentMethod:@"Test method"];
    NSUInteger countAfter = [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME];
    XCTAssertEqual(countBefore + 1, countAfter);
}

- (void)testMethodUpdated {
    NSUInteger countBefore = [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME];

    PaymentMethod *method = [[[self.db fetchedAdapterForPaymentMethods] allObjects] firstObject];
    [method setMethod:@"ALTERED NAME"];
    [self.db updatePaymentMethod:method];
    
    NSUInteger countAfter = [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME];
    XCTAssertEqual(countBefore, countAfter);

    PaymentMethod *loaded = [self.db methodById:method.objectId];
    XCTAssertNotNil(loaded);
    XCTAssertEqualObjects(@"ALTERED NAME", loaded.method);
}

- (void)testMethodDeleted {
    NSUInteger countBefore = [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME];

    PaymentMethod *method = [[[self.db fetchedAdapterForPaymentMethods] allObjects] firstObject];
    [self.db deletePaymentMethod:method];

    NSUInteger countAfter = [self.db countRowsInTable:PaymentMethodsTable.TABLE_NAME];
    XCTAssertEqual(countBefore - 1, countAfter);
}

- (void)testExistingMethodCheck {
    NSString *testMethodName = @"Test method - 123456789";
    [self.db insertPaymentMethod:testMethodName];

    XCTAssertTrue([self.db hasPaymentMethodWithName:testMethodName]);
    XCTAssertTrue([self.db hasPaymentMethodWithName:[testMethodName stringByAppendingString:@" "]]);
    XCTAssertTrue([self.db hasPaymentMethodWithName:[testMethodName uppercaseString]]);
}

@end
