//
//  DatabaseCurrenciesTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WBTrip.h"
#import "DatabaseTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "WBPreferences.h"
#import "DatabaseTableNames.h"
#import "Database+Receipts.h"
#import "Database+Distances.h"

@interface Database (TestExpose)

- (NSString *)aggregateCurrencyCodeForTrip:(WBTrip *)trip;

@end

@interface DatabaseCurrenciesTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseCurrenciesTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTrip:@{}];
}

- (void)testSingleCurrencyOnlyOnReceipts {
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"USD"}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"USD"}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"USD"}];

    NSString *currency = [self.db currencyForTripReceipts:self.trip];
    XCTAssertEqualObjects(@"USD", currency);
}

- (void)testMultiCurrencyOnlyOnReceipts {
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"USD"}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"EUR"}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"DKK"}];

    NSString *currency = [self.db currencyForTripReceipts:self.trip];
    XCTAssertEqualObjects(MULTI_CURRENCY, currency);
}

- (void)testSingleCurrencyOnlyOnDistances {
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT : self.trip, DistanceTable.COLUMN_RATE_CURRENCY : @"USD"}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY: @"USD"}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY: @"USD"}];

    NSString *currency = [self.db currencyForTripDistances:self.trip];
    XCTAssertEqualObjects(@"USD", currency);
}

- (void)testMultiCurrencyOnlyOnDistances {
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY: @"USD"}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY: @"EUR"}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY: @"DKK"}];

    NSString *currency = [self.db currencyForTripDistances:self.trip];
    XCTAssertEqualObjects(MULTI_CURRENCY, currency);
}

- (void)testReceiptsDistancesSameCurrency {
    [WBPreferences setTheDistancePriceBeIncludedInReports:YES];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"USD"}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY : @"USD"}];

    NSString *aggregate = [self.db aggregateCurrencyCodeForTrip:self.trip];
    XCTAssertEqualObjects(@"USD", aggregate);
}

- (void)testReceiptsDistancesDifferentCurrency {
    [WBPreferences setTheDistancePriceBeIncludedInReports:YES];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_ISO4217: @"USD"}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_RATE_CURRENCY : @"EUR"}];

    NSString *aggregate = [self.db aggregateCurrencyCodeForTrip:self.trip];
    XCTAssertEqualObjects(MULTI_CURRENCY, aggregate);
}

@end
