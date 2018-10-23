//
//  TripsToReceiptsConverterTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 12/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "NSDate+Calculations.h"
#import "Database+Distances.h"
#import "DistancesToReceiptsConverter.h"

@interface DistancesToReceiptsConverter (TestExpose)

- (id)initWithDistances:(NSArray *)distances;
- (NSArray *)generateReceipts;

@end

@interface TripsToReceiptsConverterTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation TripsToReceiptsConverterTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTestTrip:@{}];

    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DATE : [NSDate date]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DATE : [NSDate date]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DATE : [[NSDate date] dateByAddingDays:-1]}];
    [self.db insertTestDistance:@{DistanceTable.COLUMN_PARENT_ID : self.trip, DistanceTable.COLUMN_DATE : [[NSDate date] dateByAddingDays:-2]}];
}

- (void)testThreeReceiptsGenerated {
    NSArray *distances = [self.db allDistancesForTrip:self.trip];
    DistancesToReceiptsConverter *converter = [[DistancesToReceiptsConverter alloc] initWithDistances:distances];
    NSArray *receipts = [converter generateReceipts];
    XCTAssertNotNil(receipts);
    XCTAssertEqual(3, receipts.count);
}

@end
