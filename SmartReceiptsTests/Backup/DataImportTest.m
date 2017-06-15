//
//  DataImportTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Calculations.h"
#import "WBPreferencesTestHelper.h"
#import "SmartReceiptsTestsBase.h"
#import "Constants.h"
#include <SmartReceipts-Swift.h>

NSString *const ImportTestFileName = @"2015_05_26_SmartReceipts.smr";

@interface DataImportTest : SmartReceiptsTestsBase

@property (nonatomic, strong) DataImport *dataImport;
@property (nonatomic, copy) NSString *exportPath;

@end

@implementation DataImportTest

- (void)setUp {
    [super setUp];

    self.exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Eported.%@", [NSDate date].milliseconds]];
    NSString *importFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:ImportTestFileName ofType:@""];
    self.dataImport = [[DataImport alloc] initWithInputFile:importFilePath output:self.exportPath];

    [WBPreferences setPredictCategories:NO];
    [WBPreferences setMatchCommentToCategory:YES];
    [WBPreferences setTheDistancePriceBeIncludedInReports:YES];
}

- (void)tearDown {
    [super tearDown];

    [[NSFileManager defaultManager] removeItemAtPath:self.exportPath error:nil];
}

- (void)testImport {
    [self.dataImport execute];

    NSString *databaseBackup = [self.exportPath stringByAppendingPathComponent:SmartReceiptsDatabaseExportName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:databaseBackup]);
    NSString *tripsFolder = [self.exportPath stringByAppendingPathComponent:SmartReceiptsTripsDirectoryName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:tripsFolder]);
    NSString *testTripFolder = [tripsFolder stringByAppendingPathComponent:@"Test"];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:testTripFolder]);
    NSString *testTripFile = [testTripFolder stringByAppendingPathComponent:@"3_Fo.jpg"];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:testTripFile]);

    //Imported preferences should have changed these settings
    XCTAssertTrue([WBPreferences predictCategories]);
    XCTAssertFalse([WBPreferences matchCommentToCategory]);
    XCTAssertFalse([WBPreferences isTheDistancePriceBeIncludedInReports]);
}

@end
