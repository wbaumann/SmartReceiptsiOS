//
//  DatabaseDistancesSumTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 08/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "WBTrip.h"
#import "DatabaseTableNames.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database+Distances.h"

@interface DatabaseDistancesSumTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseDistancesSumTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db createTestTrip];
}


- (void)testSumOfDistances {
    [self.db insertDistance:@{}];
    [self.db insertDistance:@{}];

    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"10"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"1"]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"10"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"2"]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberOrZero:@"10"], DistanceTable.COLUMN_RATE: [NSDecimalNumber decimalNumberOrZero:@"3"]}];

    NSDecimalNumber *sum = [self.db sumOfDistancesForTrip:self.trip];
    XCTAssertEqualObjects([NSDecimalNumber decimalNumberWithString:@"60"], sum);
}

@end
