//
//  DataImport.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DataImport.h"
#import "Objective-Zip.h"
#import "Constants.h"
#import "WBFileManager.h"
#import "WBPreferences.h"

@interface DataImport ()

@property (nonatomic, copy) NSString *inputPath;
@property (nonatomic, copy) NSString *outputPath;

@end

@implementation DataImport

- (id)initWithInputFile:(NSString *)inputPath output:(NSString *)outputPath {
    self = [self init];
    if (self) {
        _inputPath = inputPath;
        _outputPath = outputPath;
    }
    return self;
}

- (void)execute {
    NSError *error;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:self.outputPath withIntermediateDirectories:YES attributes:nil error:&error];
    if ((result == NO) || error != nil) {
        LOGGER_ERROR(@"execute(), error creating directory at path: %@, error: %@", self.outputPath, error.description);
    }
    
    OZZipFile *zipFile = [[OZZipFile alloc] initWithFileName:self.inputPath mode:OZZipFileModeUnzip];
    [self extractFromZip:zipFile zipName:SmartReceiptsDatabaseExportName toFile:[self.outputPath stringByAppendingPathComponent:SmartReceiptsDatabaseExportName]];
    NSData *preferences = [self extractDataFromZip:zipFile withName:SmartReceiptsPreferencesExportName];
    [WBPreferences setFromXmlString:[[NSString alloc] initWithData:preferences encoding:NSUTF8StringEncoding]];

    // trips contents
    [zipFile goToFirstFileInZip];
    do {
        OZFileInZipInfo *info = [zipFile getCurrentFileInZipInfo];
        NSString *name = info.name;
        if ([name isEqualToString:SmartReceiptsDatabaseExportName]) {
            continue;
        }
        if ([name hasPrefix:@"shared_prefs/"]) {
            continue;
        }

        NSArray *components = [name pathComponents];
        if (components.count != 2) {
            continue;
        }

        NSString *tripName = components[0];
        NSString *fileName = components[1];

        LOGGER_INFO(@"Extract file for trip:%@", tripName);
        NSString *tripPath = [[self.outputPath stringByAppendingPathComponent:SmartReceiptsTripsDirectoryName] stringByAppendingPathComponent:tripName];
        [[NSFileManager defaultManager] createDirectoryAtPath:tripPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [tripPath stringByAppendingPathComponent:fileName];
        OZZipReadStream *stream = [zipFile readCurrentFileInZip];
        [self writeDataFromStream:stream toFile:filePath];
    } while ([zipFile goToNextFileInZip]);
}

- (NSData *)extractDataFromZip:(OZZipFile *)zipFile withName:(NSString *)fileName {
    NSString *tempFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"extract"];
    [self extractFromZip:zipFile zipName:fileName toFile:tempFile];
    NSData *data = [NSData dataWithContentsOfFile:tempFile];
    [[NSFileManager defaultManager] removeItemAtPath:tempFile error:nil];
    return data;
}

- (void)extractFromZip:(OZZipFile *)zipFile zipName:(NSString *)zipName toFile:(NSString *)outPath {
    LOGGER_DEBUG(@"Extract file named: %@", zipName);
    BOOL found = [zipFile locateFileInZip:zipName];
    if (!found) {
        LOGGER_WARNING(@"File with name %@ not in zip", zipName);
        return;
    }

    OZZipReadStream *stream = [zipFile readCurrentFileInZip];
    [self writeDataFromStream:stream toFile:outPath];
}

- (void)writeDataFromStream:(OZZipReadStream *)stream toFile:(NSString *)file {
    @autoreleasepool {
        NSMutableData *buffer = [[NSMutableData alloc] initWithLength:(8 * 1024)];
        NSMutableData *resultData = [[NSMutableData alloc] init];
        NSUInteger len;
        while ((len = [stream readDataWithBuffer:buffer]) > 0) {
            [resultData appendBytes:[buffer mutableBytes] length:len];
        }
        [stream finishedReading];

        LOGGER_DEBUG(@"File size %tu", resultData.length);
        [WBFileManager forceWriteData:resultData to:file];
        LOGGER_DEBUG(@"Written to %@", file);
    }
}

@end
