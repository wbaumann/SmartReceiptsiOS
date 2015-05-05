//
//  DatabaseDistancesTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DatabaseTestsBase.h"
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "Distance.h"
#import "WBTrip.h"
#import "WBPrice.h"
#import "Database+Distances.h"
#import "DatabaseTestsHelper.h"

@interface Distance (TestExpose)

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment;

@end

@interface DatabaseDistancesTest : DatabaseTestsBase

@end

@implementation DatabaseDistancesTest

- (void)testSaveDistance {
    self.db = [self createAndOpenDatabaseWithPath:self.testDBPath migrated:YES];

    XCTAssertEqual(0, [self.db countRowsInTable:DistanceTable.TABLE_NAME]);

    Distance *distance = [self createTestDistance];
    [self.db saveDistance:distance];

    XCTAssertEqual(1, [self.db countRowsInTable:DistanceTable.TABLE_NAME]);
}

- (Distance *)createTestDistance {
    WBTrip *testTrip = [self.db createTestTrip];
    return [[Distance alloc] initWithTrip:testTrip
                                 distance:[NSDecimalNumber decimalNumberWithString:@"10"]
                                     rate:[WBPrice priceWithAmount:[NSDecimalNumber decimalNumberWithString:@"1"] currencyCode:@"EUR"]
                                 location:@"Location"
                                     date:[NSDate date]
                                 timeZone:[NSTimeZone defaultTimeZone]
                                  comment:@"Comment"];
}

@end
