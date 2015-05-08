//
//  DatabaseTripsSumTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 08/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "ReportTable.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database+Trips.h"
#import "WBPreferences.h"
#import "WBPrice.h"

@interface DatabaseTripsSumTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseTripsSumTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTrip:@{}];

    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"1"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"2"]}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"3"]}];

    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"1"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"10"]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"1"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"20"]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"1"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"30"]}];

    [WBPreferences setOnlyIncludeExpensableReceiptsInReports:NO];
    [WBPreferences setTheDistancePriceBeIncludedInReports:YES];
}


- (void)testSumOfTripWithDistances {
    NSDecimalNumber *sum = [self.db totalPriceForTrip:self.trip];
    XCTAssertEqualObjects([NSDecimalNumber decimalNumberOrZero:@"66"], sum);
}

- (void)testSumOfTripWithoutDistances {
    [WBPreferences setTheDistancePriceBeIncludedInReports:NO];

    NSDecimalNumber *sum = [self.db totalPriceForTrip:self.trip];
    XCTAssertEqualObjects([NSDecimalNumber decimalNumberOrZero:@"6"], sum);
}

- (void)testTripPriceUpdatedOnDistanceEntry {
    NSDecimalNumber *startPrice = [self.db totalPriceForTrip:self.trip];

    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"10"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"10"]}];

    WBTrip *fetched = [self.db tripWithName:self.trip.name];
    NSDecimalNumber *expected = [startPrice decimalNumberByAdding:[NSDecimalNumber decimalNumberOrZero:@"100"]];
    XCTAssertEqualObjects(expected, fetched.price.amount);
}

- (void)testTripPriceUpdatedOnReceiptEntry {
    NSDecimalNumber *startPrice = [self.db totalPriceForTrip:self.trip];

    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: self.trip, ReceiptsTable.COLUMN_PRICE: [NSDecimalNumber decimalNumberOrZero:@"50"]}];

    WBTrip *fetched = [self.db tripWithName:self.trip.name];
    NSDecimalNumber *expected = [startPrice decimalNumberByAdding:[NSDecimalNumber decimalNumberOrZero:@"50"]];
    XCTAssertEqualObjects(expected, fetched.price.amount);
}

@end
