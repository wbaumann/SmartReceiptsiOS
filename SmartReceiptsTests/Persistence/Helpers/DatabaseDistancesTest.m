//
//  DatabaseDistancesTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "Database+Distances.h"

@interface DatabaseDistancesTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *testTrip;

@end

@implementation DatabaseDistancesTest

- (void)setUp {
    [super setUp];

    self.testTrip = [self.db createTestTrip];
}


- (void)testSaveDistance {
    NSUInteger countBefore = [self.db countRowsInTable:DistanceTable.TABLE_NAME];

    [self.db insertTestDistance:@{}];

    NSUInteger countAfter = [self.db countRowsInTable:DistanceTable.TABLE_NAME];

    XCTAssertEqual(countBefore + 1, countAfter);
}

- (void)testDistanceTraveledForTrip {
    [self.db insertTestDistance:@{DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberWithString:@"20"]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberWithString:@"20"]}];

    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT: self.testTrip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberWithString:@"20"]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT: self.testTrip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberWithString:@"30"]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT: self.testTrip, DistanceTable.COLUMN_DISTANCE: [NSDecimalNumber decimalNumberWithString:@"50"]}];

    NSDecimalNumber *totalDistance = [self.db totalDistanceTraveledForTrip:self.testTrip];
    XCTAssertEqualObjects([NSDecimalNumber decimalNumberWithString:@"100"], totalDistance);
}

@end
