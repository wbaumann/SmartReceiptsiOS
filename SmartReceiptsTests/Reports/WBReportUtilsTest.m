//
//  WBReportUtilsTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WBPreferences.h"
#import "WBReceipt.h"
#import "WBReportUtils.h"
#import "Price.h"
#import "WBPreferencesTestHelper.h"
#import "WBCurrency.h"

@interface WBReportUtilsTest : XCTestCase

@property (nonatomic, strong) WBPreferencesTestHelper *preferencesHelper;

@end

@implementation WBReportUtilsTest

- (void)setUp {
    self.preferencesHelper = [[WBPreferencesTestHelper alloc] init];
    [self.preferencesHelper createPreferencesBackup];
    [WBPreferences setOnlyIncludeExpensableReceiptsInReports:YES];
}

- (void)tearDown {
    [self.preferencesHelper restorePreferencesBackup];
}

- (void)testFiltersOutNonExpensableWhenSettingToIncludeOnlyExpensable {
    WBReceipt *receipt = [self createTestReceipt:NO];
    XCTAssertTrue([WBReportUtils filterOutReceipt:receipt]);
}

- (void)testDoesNotFilterExpensableWhenSettingToIncludeOnlyExpensable {
    WBReceipt *receipt = [self createTestReceipt:YES];
    XCTAssertFalse([WBReportUtils filterOutReceipt:receipt]);
}

- (void)testDoesNotFilterNonExpensableWhenSettingToIncludeOnlyExpensableIsOff {
    [WBPreferences setOnlyIncludeExpensableReceiptsInReports:NO];
    WBReceipt *receipt = [self createTestReceipt:NO];
    XCTAssertFalse([WBReportUtils filterOutReceipt:receipt]);
}

- (void)testReceiptFilteredBasedOnAmount {
    [WBPreferences setMinimumReceiptPriceToIncludeInReports:100000];
    WBReceipt *receipt = [self createTestReceipt:YES];
    XCTAssertTrue([WBReportUtils filterOutReceipt:receipt]);
}

- (WBReceipt *)createTestReceipt:(BOOL)expensable {
    return [[WBReceipt alloc] initWithId:1 name:@"" category:@"" imageFileName:@"" date:[NSDate date] timeZoneName:@"" comment:@"" priceAmount:[NSDecimalNumber decimalNumberWithString:@"10"] taxAmount:[NSDecimalNumber zero] currency:[WBCurrency currencyForCode:@"USD"] isExpensable:expensable isFullPage:NO extraEditText1:@"" extraEditText2:@"" extraEditText3:@""];
}

@end
