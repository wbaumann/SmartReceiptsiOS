//
//  DatabaseTripsSumTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 08/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "ReportTable.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database+Trips.h"
#import "WBPreferences.h"


@interface Database(Expose)

- (WBTrip *)tripWithName:(NSString *)name;

@end

@interface DatabaseTripsSumTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseTripsSumTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTestTrip:@{}];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"1"]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"2"]}];
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT_ID : self.trip, ReceiptsTable.COLUMN_PRICE : [NSDecimalNumber decimalNumberOrZero:@"3"]}];

    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DISTANCE : [NSDecimalNumber decimalNumberOrZero:@"1"], DistanceTable.COLUMN_RATE : [NSDecimalNumber decimalNumberOrZero:@"10"]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DISTANCE : [NSDecimalNumber decimalNumberOrZero:@"1"], DistanceTable.COLUMN_RATE : [NSDecimalNumber decimalNumberOrZero:@"20"]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DISTANCE : [NSDecimalNumber decimalNumberOrZero:@"1"], DistanceTable.COLUMN_RATE : [NSDecimalNumber decimalNumberOrZero:@"30"]}];

    [WBPreferences setOnlyIncludeReimbursableReceiptsInReports:NO];
    [WBPreferences setTheDistancePriceBeIncludedInReports:YES];
}


- (void)testSumOfTripWithDistances {
    WBTrip *trip = [self.db tripWithName:self.trip.name];
    XCTAssertEqualObjects(@"$66.00", trip.formattedPrice);
}

- (void)testSumOfTripWithoutDistances {
    [WBPreferences setTheDistancePriceBeIncludedInReports:NO];

    WBTrip *trip = [self.db tripWithName:self.trip.name];
    XCTAssertEqualObjects(@"$6.00", trip.formattedPrice);
}

@end
