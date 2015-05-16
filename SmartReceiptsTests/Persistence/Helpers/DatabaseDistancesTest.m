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
#import "DatabaseTestsHelper.h"

@interface Distance (TestExpose)

- (id)initWithTrip:(WBTrip *)trip distance:(NSDecimalNumber *)distance rate:(WBPrice *)rate location:(NSString *)location date:(NSDate *)date timeZone:(NSTimeZone *)timeZone comment:(NSString *)comment;

@end

@interface DatabaseDistancesTest : DatabaseTestsBase

@end

@implementation DatabaseDistancesTest

- (void)testSaveDistance {
    XCTAssertEqual(0, [self.db countRowsInTable:DistanceTable.TABLE_NAME]);

    [self.db insertTestDistance:@{}];

    XCTAssertEqual(1, [self.db countRowsInTable:DistanceTable.TABLE_NAME]);
}

@end
