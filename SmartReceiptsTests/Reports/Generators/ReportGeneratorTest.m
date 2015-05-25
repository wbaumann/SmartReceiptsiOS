//
//  ReportGeneratorTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "WBTrip.h"
#import "WBDB.h"
#import "Price.h"
#import "ReportGenerator.h"
#import "WBPreferences.h"
#import "WBPreferencesTestHelper.h"
#import "SmartReceiptsTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"

@interface ReportGeneratorTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *testTrip;

@end

@implementation ReportGeneratorTest

- (void)setUp {
    [super setUp];

    self.db = [self createTestDatabase];

    self.testTrip = [self.db insertTestTrip:@{}];
}

- (void)testReceiptsProvidedHaveTripObject {
    [self createTestReceipt:1];
    [self createTestReceipt:2];
    [self createTestReceipt:3];
    
    ReportGenerator *generator = [[ReportGenerator alloc] initWithTrip:self.testTrip database:self.db];
    NSArray *receipts = [generator receipts];
    XCTAssertEqual(3, receipts.count);
    for (WBReceipt *receipt in receipts) {
        XCTAssertNotNil(receipt.trip);
    }
}

- (void)createTestReceipt:(NSInteger)marker {
    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME : [NSString stringWithFormat:@"TEST Receipt %tu", marker], ReceiptsTable.COLUMN_PARENT : self.testTrip}];
}

@end
