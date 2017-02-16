//
//  DataExport.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DataExport.h"
#import "Objective-Zip.h"
#import "Constants.h"
#import "WBPreferences.h"

@interface DataExport ()

@property (nonatomic, copy) NSString *workDirectory;

@end

@implementation DataExport

- (id)initWithWorkDirectory:(NSString *)pathToDirectory {
    self = [super init];
    if (self) {
        _workDirectory = pathToDirectory;
    }
    return self;
}

- (NSString *)execute {
    NSString *zipPath = [self.workDirectory stringByAppendingPathComponent:SmartReceiptsExportName];

    LOGGER_INFO(@"execute at path: %@", zipPath);
    OZZipFile *zipFile = [[OZZipFile alloc] initWithFileName:zipPath mode:OZZipFileModeCreate];
    LOGGER_INFO(@"zipFile legacy32BitMode: %@", zipFile.legacy32BitMode ? @"YES" : @"NO");
    [self appendFileNamed:SmartReceiptsDatabaseName inDirectory:self.workDirectory archiveName:SmartReceiptsDatabaseExportName toZip:zipFile];
    [self appendAllTripFilesToZip:zipFile];
    NSData *preferences = [[WBPreferences xmlString] dataUsingEncoding:NSUTF8StringEncoding];
    [self appendData:preferences zipName:SmartReceiptsPreferencesExportName toFile:zipFile];
    [zipFile close];

    return zipPath;
}

- (void)appendData:(NSData *)data zipName:(NSString *)zipName toFile:(OZZipFile *)zipFile {
    LOGGER_INFO(@"appendData: size %li, zipName: %@, toFile %@", data.length, zipName, zipFile);
    OZZipWriteStream *stream = [zipFile writeFileInZipWithName:zipName compressionLevel:OZZipCompressionLevelDefault];
    [stream writeData:data];
    [stream finishedWriting];
}

- (void)appendAllTripFilesToZip:(OZZipFile *)file {
    NSString *tripsFolder = [self.workDirectory stringByAppendingPathComponent:SmartReceiptsTripsDirectoryName];
    NSError *error;
    NSArray *trips = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tripsFolder error:&error];
    if (error) {
        LOGGER_ERROR(@"appendAllTripFilesToZip error: %@", error.description);
    }
    
    for (NSString *trip in trips) {
        [self appFilesForTrip:trip toZip:file];
    }
}

- (void)appFilesForTrip:(NSString *)trip toZip:(OZZipFile *)zip {
    NSString *tripFolder = [[self.workDirectory stringByAppendingPathComponent:SmartReceiptsTripsDirectoryName] stringByAppendingPathComponent:trip];
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tripFolder error:&error];
    if (error) {
        LOGGER_ERROR(@"appFilesForTrip:toZip: error: %@", error.description);
    }
    
    for (NSString *file in files) {
        NSString *zipName = [trip stringByAppendingPathComponent:file];
        [self appendFileNamed:file inDirectory:tripFolder archiveName:zipName toZip:zip];
    }
}

- (void)appendFileNamed:(NSString *)fileName inDirectory:(NSString *)containingDirectory archiveName:(NSString *)archiveName toZip:(OZZipFile *)zipFile {
    NSString *filePath = [containingDirectory stringByAppendingPathComponent:fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [self appendData:fileData zipName:archiveName toFile:zipFile];
}

@end
