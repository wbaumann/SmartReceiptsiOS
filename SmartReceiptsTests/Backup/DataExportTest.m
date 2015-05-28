//
//  DataExportTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+Calculations.h"
#import "Constants.h"
#import "DataExport.h"
#import "ZipFile.h"
#import "FileInZipInfo.h"

@interface DataExportTest : XCTestCase

@property (nonatomic, copy) NSString *testPath;
@property (nonatomic, strong) NSDictionary *files;

@end

@implementation DataExportTest

- (void)setUp {
    [super setUp];

    self.testPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"EXPORT_%@", [NSDate date].milliseconds]];

    NSDictionary *files = @{
            @"" : SmartReceiptsDatabaseName,
            [SmartReceiptsTripsDirectoryName stringByAppendingPathComponent:@"Trip One"] : @"uber-image.jpg",
            [SmartReceiptsTripsDirectoryName stringByAppendingPathComponent:@"Trip Two"] : @"cakes-on-the-plane.pdf",
            [SmartReceiptsTripsDirectoryName stringByAppendingPathComponent:@"Trip Three"] : @"smoked.png",
    };

    NSMutableDictionary *preferencesAdded = [NSMutableDictionary dictionaryWithDictionary:files];
    NSArray *atoms = [SmartReceiptsPreferencesExportName componentsSeparatedByString:@"/"];
    preferencesAdded[atoms.firstObject] = atoms.lastObject;
    self.files = [NSDictionary dictionaryWithDictionary:preferencesAdded];

    for (NSString *folder in files) {
        NSString *path = [self.testPath stringByAppendingPathComponent:folder];
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *file = files[folder];
        NSString *filePath = [path stringByAppendingPathComponent:file];
        [[filePath dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    }
}

- (void)tearDown {
    [super tearDown];

    [[NSFileManager defaultManager] removeItemAtPath:self.testPath error:nil];
}

- (void)testAllFilesIncludedInZip {
    DataExport *export = [[DataExport alloc] initWithWorkDirectory:self.testPath];
    NSString *pathToSRM = [export execute];
    XCTAssertNotNil(pathToSRM);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:pathToSRM]);
    XCTAssertTrue([self zipAtPath:pathToSRM containsAllFiles:self.files]);
}

- (BOOL)zipAtPath:(NSString *)zipPath containsAllFiles:(NSDictionary *)files {
    ZipFile *file = [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];
    NSArray *fileNames = file.listFileInZipInfos;
    if (fileNames.count != files.count) {
        SRLog(@"Have %tu files in zip, expected %tu", fileNames.count, files.count);
        return NO;
    }

    NSMutableArray *joinedFiles = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *key in files) {
        NSString *value = files[key];
        if ([value isEqualToString:SmartReceiptsDatabaseName]) {
            value = SmartReceiptsDatabaseExportName;
        }
        [joinedFiles addObject:[key stringByAppendingPathComponent:value]];
    }

    for (FileInZipInfo *info in fileNames) {
        SRLog(@"File: %@ - %@", info.name, joinedFiles);
        if (![joinedFiles containsObject:info.name]) {
            return NO;
        }
        [joinedFiles removeObject:info.name];
    }

    if (joinedFiles.count != 0) {
        SRLog(@"Did not see following files in zip %@", joinedFiles);
        return NO;
    }

    return YES;
}

@end
