//
//  FetchedDistancesAdapterTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "FetchedModelAdapter.h"
#import "WBTrip.h"
#import "DatabaseTestsHelper.h"
#import "Database+Distances.h"
#import "Distance.h"

@interface FetchedDistancesAdapterTest : DatabaseTestsBase

@property (nonatomic, strong) FetchedModelAdapter *adapter;

@end

@implementation FetchedDistancesAdapterTest

- (void)setUp {
    [super setUp];

    self.db = [self createAndOpenDatabaseWithPath:self.testDBPath migrated:YES];

    WBTrip *dummyTrip = [self.db createTestTrip];

    WBTrip *testTrip = [self.db createTestTrip];
    [self.db insertDistance:@{@"trip" : dummyTrip}];
    [self.db insertDistance:@{@"trip" : testTrip, @"date" : [NSDate date], @"location" : @"One"}];
    [self.db insertDistance:@{@"trip" : dummyTrip}];
    [self.db insertDistance:@{@"trip" : testTrip, @"date" : [[NSDate date] dateByAddingTimeInterval:-100], @"location" : @"Two"}];
    [self.db insertDistance:@{@"trip" : dummyTrip}];
    [self.db insertDistance:@{@"trip" : testTrip, @"date" : [[NSDate date] dateByAddingTimeInterval:100], @"location" : @"Three"}];
    [self.db insertDistance:@{@"trip" : dummyTrip}];

    self.adapter = [self.db fetchedAdapterForDistancesInTrip:testTrip];
}

- (void)testAdapterFetchResult {
    XCTAssertEqual(3, self.adapter.numberOfObjects);
    Distance *first = [self.adapter objectAtIndex:0];
    XCTAssertNotNil(first);
    XCTAssertEqualObjects(@"Three", first.location);
}

@end
