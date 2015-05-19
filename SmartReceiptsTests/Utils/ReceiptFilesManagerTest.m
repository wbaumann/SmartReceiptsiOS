//
//  ReceiptFilesManagerTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "Database.h"
#import "DatabaseTestsHelper.h"
#import "DatabaseTableNames.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@interface ReceiptFilesManagerTest : SmartReceiptsTestsBase

@property (nonatomic, strong) WBReceipt *testReceipt;

@end

@implementation ReceiptFilesManagerTest

- (void)setUp {
    [super setUp];

    UIImage *receiptImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"sample-receipt" ofType:@"jpg"]];

    [self.db insertTestReceipt:@{ReceiptsTable.COLUMN_NAME: @"TestReceipt"}];
    self.testReceipt = [self.db receiptWithName:@"TestReceipt"];

    [self.db.filesManager saveImage:receiptImage forReceipt:self.testReceipt];
}

- (void)testCopyReceiptFile {
    NSString *originalPath = [self.db.filesManager pathForReceiptFile:self.testReceipt];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);

    WBTrip *trip = self.db.createTestTrip;
    [self.db.filesManager copyFileForReceipt:self.testReceipt toTrip:trip];
    [self.testReceipt setTrip:trip];

    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);
    NSString *copiedPath = [self.db.filesManager pathForReceiptFile:self.testReceipt];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:copiedPath]);
}

- (void)testMoveReceiptFile {
    NSString *originalPath = [self.db.filesManager pathForReceiptFile:self.testReceipt];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);

    WBTrip *trip = self.db.createTestTrip;
    [self.db.filesManager moveFileForReceipt:self.testReceipt toTrip:trip];
    [self.testReceipt setTrip:trip];

    XCTAssertTrue(![[NSFileManager defaultManager] fileExistsAtPath:originalPath]);
    NSString *movedPath = [self.db.filesManager pathForReceiptFile:self.testReceipt];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:movedPath]);
}

- (void)testFileDelete {
    NSString *originalPath = [self.db.filesManager pathForReceiptFile:self.testReceipt];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);

    [self.db.filesManager deleteFileForReceipt:self.testReceipt];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:originalPath]);
}

- (void)testTripFolderDelete {
    WBTrip *trip = [self.db createTestTrip];
    NSString *path = [self.db.filesManager receiptsFolderForTrip:trip];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
    [self.db.filesManager deleteFolderForTrip:trip];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

- (void)testTripFolderMove {
    WBTrip *trip = [self.db createTestTrip];
    NSString *path = [self.db.filesManager receiptsFolderForTrip:trip];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
    NSString *originalName = trip.name;
    trip.name = @"Altered trip name";
    [self.db.filesManager renameFolderForTrip:trip originalName:originalName];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[self.db.filesManager receiptsFolderForTrip:trip]]);
}

@end
