//
//  TripsToReceiptsConverterTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 12/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
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

@interface TripsToReceiptsConverterTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation TripsToReceiptsConverterTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTrip:@{}];

    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DATE: [NSDate date]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DATE: [NSDate date]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DATE: [[NSDate date] dateByAddingDays:-1]}];
    [self.db insertDistance:@{DistanceTable.COLUMN_PARENT: self.trip, DistanceTable.COLUMN_DATE: [[NSDate date] dateByAddingDays:-2]}];
}

- (void)testThreeReceiptsGenerated {
    NSArray *distances = [self.db allDistancesForTrip:self.trip];
    DistancesToReceiptsConverter *converter = [[DistancesToReceiptsConverter alloc] initWithDistances:distances];
    NSArray *receipts = [converter generateReceipts];
    XCTAssertNotNil(receipts);
    XCTAssertEqual(3, receipts.count);
}

@end
