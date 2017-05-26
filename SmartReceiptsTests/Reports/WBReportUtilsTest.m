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
#import <SmartReceipts-Swift.h>

@interface WBReportUtilsTest : XCTestCase

@property (nonatomic, strong) WBPreferencesTestHelper *preferencesHelper;

@end

@implementation WBReportUtilsTest

- (void)setUp {
    self.preferencesHelper = [[WBPreferencesTestHelper alloc] init];
    [self.preferencesHelper createPreferencesBackup];
    [WBPreferences setOnlyIncludeReimbursableReceiptsInReports:YES];
}

- (void)tearDown {
    [self.preferencesHelper restorePreferencesBackup];
}

- (void)testFiltersOutNonReimbursableWhenSettingToIncludeOnlyReimbursable {
    WBReceipt *receipt = [self createTestReceipt:NO];
    XCTAssertTrue([WBReportUtils filterOutReceipt:receipt]);
}

- (void)testDoesNotFilterReimbursableWhenSettingToIncludeOnlyReimbursable {
    WBReceipt *receipt = [self createTestReceipt:YES];
    XCTAssertFalse([WBReportUtils filterOutReceipt:receipt]);
}

- (void)testDoesNotFilterNonReimbursableWhenSettingToIncludeOnlyReimbursableIsOff {
    [WBPreferences setOnlyIncludeReimbursableReceiptsInReports:NO];
    WBReceipt *receipt = [self createTestReceipt:NO];
    XCTAssertFalse([WBReportUtils filterOutReceipt:receipt]);
}

- (void)testReceiptFilteredBasedOnAmount {
    [WBPreferences setMinimumReceiptPriceToIncludeInReports:100000];
    WBReceipt *receipt = [self createTestReceipt:YES];
    XCTAssertTrue([WBReportUtils filterOutReceipt:receipt]);
}

- (WBReceipt *)createTestReceipt:(BOOL)reimbursable {
    return [[WBReceipt alloc] initWithId:1 name:@"" category:@"" imageFileName:@"" date:[NSDate date] timeZoneName:@"" comment:@"" priceAmount:[NSDecimalNumber decimalNumberWithString:@"10"] taxAmount:[NSDecimalNumber zero] currency:[Currency currencyForCode:@"USD"] isReimbursable:reimbursable isFullPage:NO extraEditText1:@"" extraEditText2:@"" extraEditText3:@""];
}

@end
