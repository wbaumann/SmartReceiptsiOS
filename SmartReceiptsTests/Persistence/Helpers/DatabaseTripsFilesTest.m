//
//  DatabaseTripsFilesTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 19/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "DatabaseTableNames.h"
#import "Database+Trips.h"

@interface DatabaseTripsFilesTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBTrip *testTrip;

@end

@implementation DatabaseTripsFilesTest

- (void)setUp {
    [super setUp];

    [self.db insertTestTrip:@{TripsTable.COLUMN_NAME: @"TestTrip123"}];
    self.testTrip = [self.db tripWithName:@"TestTrip123"];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_PARENT: self.testTrip, ReceiptsTable.COLUMN_NAME: @"Receipt"}];
    WBReceipt *receipt = [self.db receiptWithName:@"Receipt"];


    UIImage *receiptImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sample-receipt" ofType:@"jpg"]];
    [self.db.filesManager saveImage:receiptImage forReceipt:receipt];
}

- (void)testOnTripDeleteFilesRemoved {
    BOOL isDir = NO;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self.db.filesManager receiptsFolderForTrip:self.testTrip] isDirectory:&isDir]);
    XCTAssertTrue(isDir);

    [self.db deleteTrip:self.testTrip];

    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[self.db.filesManager receiptsFolderForTrip:self.testTrip]]);
}

- (void)testOnTripRenameFolderMoved {
    NSString *originalPath = [self.db.filesManager receiptsFolderForTrip:self.testTrip];

    self.testTrip.name = @"Altered";
    [self.db updateTrip:self.testTrip];

    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);
    WBTrip *loaded = [self.db tripWithName:@"Altered"];
    XCTAssertNotNil(loaded);

    BOOL isDir = NO;
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self.db.filesManager receiptsFolderForTrip:loaded] isDirectory:&isDir]);
    XCTAssertTrue(isDir);

    WBReceipt *receipt = [self.db receiptWithName:@"Receipt"];
    XCTAssertNotNil(receipt);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self.db.filesManager pathForReceiptFile:receipt withTrip:loaded]]);
}

@end
