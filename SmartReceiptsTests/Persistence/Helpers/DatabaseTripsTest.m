//
//  DatabaseTripsTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 07/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "DatabaseTableNames.h"
#import "DatabaseTestsHelper.h"
#import "Database+Functions.h"
#import "Database+Trips.h"

@interface DatabaseTripsTest : DatabaseTestsBase

@end

@implementation DatabaseTripsTest

- (void)setUp {
    [super setUp];

    self.db = [self createAndOpenDatabaseWithPath:self.testDBPath migrated:YES];
}

- (void)testTripSaved {
    NSUInteger countBefore = [self.db countRowsInTable:TripsTable.TABLE_NAME];
    [self.db insertTrip:@{}];
    NSUInteger countAfter = [self.db countRowsInTable:TripsTable.TABLE_NAME];
    XCTAssertEqual(countBefore + 1, countAfter);
}

- (void)testSelectAll {
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];

    NSArray *allTrips = [self.db allTrips];
    XCTAssertEqual(5, allTrips.count);
}

@end
