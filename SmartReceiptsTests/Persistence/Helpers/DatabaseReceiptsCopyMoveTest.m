//
//  DatabaseReceiptsCopyMoveTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBTrip.h"
#import "WBReceipt.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "Database+Trips.h"
#import "Database+Receipts.h"
#import "Database+Functions.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "WBPrice.h"

@interface DatabaseReceiptsCopyMoveTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *sourceTrip;
@property (nonatomic, strong) WBTrip *destinationTrip;
@property (nonatomic, strong) WBReceipt *testReceipt;
@property (nonatomic, strong) NSDecimalNumber *testReceiptPrice;

@end

@implementation DatabaseReceiptsCopyMoveTest

- (void)setUp {
    [super setUp];

    self.sourceTrip = [self.db insertTestTrip:@{TripsTable.COLUMN_NAME: @"Source"}];
    self.testReceiptPrice = [NSDecimalNumber decimalNumberOrZero:@"10"];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.sourceTrip, ReceiptsTable.COLUMN_NAME: @"TestReceipt", ReceiptsTable.COLUMN_PRICE: self.testReceiptPrice}];
    self.testReceipt = [self.db receiptWithName:@"TestReceipt"];

    self.destinationTrip = [self.db insertTestTrip:@{TripsTable.COLUMN_NAME: @"Destination"}];

    UIImage *receiptImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sample-receipt" ofType:@"jpg"]];
    [self.db.filesManager saveImage:receiptImage forReceipt:self.testReceipt];
}


- (void)testCopyReceipt {
    XCTAssertEqual(1, [self.db allReceiptsForTrip:self.sourceTrip].count);
    XCTAssertEqual(0, [self.db allReceiptsForTrip:self.destinationTrip].count);

    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db copyReceipt:self.testReceipt toTrip:self.destinationTrip];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];

    XCTAssertEqual(countBefore + 1, countAfter);

    XCTAssertEqual(1, [self.db allReceiptsForTrip:self.sourceTrip].count);
    XCTAssertEqual(1, [self.db allReceiptsForTrip:self.destinationTrip].count);

    WBTrip *fetchedSource = [self.db tripWithName:self.sourceTrip.name];
    XCTAssertEqualObjects(self.testReceiptPrice, fetchedSource.price.amount);

    WBTrip *fetchedDestination = [self.db tripWithName:self.destinationTrip.name];
    XCTAssertEqualObjects(self.testReceiptPrice, fetchedDestination.price.amount);

    NSString *originalPath = [self.db.filesManager pathForReceiptFile:self.testReceipt withTrip:self.sourceTrip];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);
    NSString *destinationPath = [self.db.filesManager pathForReceiptFile:self.testReceipt withTrip:self.destinationTrip];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:destinationPath], @"No file at %@", destinationPath);
}

- (void)testMoveReceipt {
    XCTAssertEqual(1, [self.db allReceiptsForTrip:self.sourceTrip].count);
    XCTAssertEqual(0, [self.db allReceiptsForTrip:self.destinationTrip].count);

    NSUInteger countBefore = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];
    [self.db moveReceipt:self.testReceipt toTrip:self.destinationTrip];
    NSUInteger countAfter = [self.db countRowsInTable:ReceiptsTable.TABLE_NAME];

    XCTAssertEqual(countBefore, countAfter);

    XCTAssertEqual(0, [self.db allReceiptsForTrip:self.sourceTrip].count);
    XCTAssertEqual(1, [self.db allReceiptsForTrip:self.destinationTrip].count);

    WBTrip *fetchedSource = [self.db tripWithName:self.sourceTrip.name];
    XCTAssertEqualObjects([NSDecimalNumber zero], fetchedSource.price.amount);

    WBTrip *fetchedDestination = [self.db tripWithName:self.destinationTrip.name];
    XCTAssertEqualObjects(self.testReceiptPrice, fetchedDestination.price.amount);

    NSString *originalPath = [self.db.filesManager pathForReceiptFile:self.testReceipt withTrip:self.sourceTrip];
    XCTAssertTrue(![[NSFileManager defaultManager] fileExistsAtPath:originalPath]);
    NSString *destinationPath = [self.db.filesManager pathForReceiptFile:self.testReceipt withTrip:self.destinationTrip];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:destinationPath]);
}

@end
