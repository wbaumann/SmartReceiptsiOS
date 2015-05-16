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
#import "WBTrip.h"
#import "NSDate+Calculations.h"
#import "WBCurrency.h"
#import "Database+Receipts.h"

@interface DatabaseTripsTest : DatabaseTestsBase

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation DatabaseTripsTest

- (void)setUp {
    [super setUp];

    self.trip = [self.db insertTrip:@{TripsTable.COLUMN_NAME: @"Test my load"}];
}

- (void)testTripSaved {
    NSUInteger countBefore = [self.db countRowsInTable:TripsTable.TABLE_NAME];
    [self.db insertTrip:@{}];
    NSUInteger countAfter = [self.db countRowsInTable:TripsTable.TABLE_NAME];
    XCTAssertEqual(countBefore + 1, countAfter);
}

- (void)testSelectAll {
    //one added in setup
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];
    [self.db insertTrip:@{}];

    NSArray *allTrips = [self.db allTrips];
    XCTAssertEqual(6, allTrips.count);
}

- (void)testSelectByName {
    WBTrip *loaded = [self.db tripWithName:@"Test my load"];
    XCTAssertNotNil(loaded);
    XCTAssertEqualObjects(@"Test my load", loaded.name);
}

- (void)testDateSaveAndLoad {
    NSString *testName = @"Testing here abz";
    [self.db insertTrip:@{TripsTable.COLUMN_NAME : testName, TripsTable.COLUMN_FROM : [NSDate date], TripsTable.COLUMN_TO : [[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 5]}];

    WBTrip *trip = [self.db tripWithName:testName];
    XCTAssertNotNil(trip);
    XCTAssertTrue([trip.startDate isToday], @"Start date is %@", trip.startDate);
}

- (void)testAdditionalFieldsSavedAndLoaded {
    NSString *testName = @"Testing my thingie";
    NSString *defaultCurrency = @"XYZ";
    NSString *comment = @"Test comment";
    NSString *costCenter = @"Test const center";

    [self.db insertTrip:@{TripsTable.COLUMN_NAME : testName, TripsTable.COLUMN_DEFAULT_CURRENCY : defaultCurrency, TripsTable.COLUMN_COMMENT : comment, TripsTable.COLUMN_COST_CENTER : costCenter}];

    WBTrip *loaded = [self.db tripWithName:testName];

    XCTAssertEqualObjects(defaultCurrency, loaded.defaultCurrency.code);
    XCTAssertEqualObjects(comment, loaded.comment);
    XCTAssertEqualObjects(costCenter, loaded.costCenter);
}

- (void)testUpdateTrip {
    NSString *testTripName = @"Tripping here";
    [self.db insertTrip:@{TripsTable.COLUMN_NAME: testTripName}];

    WBTrip *trip = [self.db tripWithName:testTripName];
    [trip setName:@"Altered XZY"];
    [trip setComment:@"My comment"];
    [trip setCostCenter:@"Cost center this"];

    [self.db updateTrip:trip];

    WBTrip *reloaded = [self.db tripWithName:@"Altered XZY"];
    XCTAssertNotNil(reloaded);
    XCTAssertEqualObjects(@"My comment", reloaded.comment);
    XCTAssertEqualObjects(@"Cost center this", reloaded.costCenter);
}

- (void)testOnTripNameReceiptsAreMoved {
    WBTrip *trip = [self.db insertTrip:@{}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}];
    [self.db insertReceipt:@{ReceiptsTable.COLUMN_PARENT: trip}];

    NSUInteger tripsCountBeforeRename = [self.db countRowsInTable:TripsTable.TABLE_NAME];

    trip.name = @"Rename me";
    [self.db updateTrip:trip];

    NSArray *receipts = [self.db allReceiptsForTrip:trip descending:YES];
    XCTAssertEqual(5, receipts.count);

    NSUInteger tripsCountAfter = [self.db countRowsInTable:TripsTable.TABLE_NAME];
    XCTAssertEqual(tripsCountBeforeRename, tripsCountAfter);
}

- (void)testDefaultCurrencyLoaded {
    NSString *testName = @"BOOOOOOOOYA";
    NSString *testCurrency = @"EUR";
    [self.db insertTrip:@{TripsTable.COLUMN_NAME: testName, TripsTable.COLUMN_DEFAULT_CURRENCY: testCurrency}];

    WBTrip *loaded = [self.db tripWithName:testName];
    XCTAssertNotNil(loaded);
    XCTAssertNotNil(loaded.defaultCurrency);
    XCTAssertEqualObjects(testCurrency, loaded.defaultCurrency.code);
}

@end
