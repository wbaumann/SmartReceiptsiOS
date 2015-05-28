//
//  DataExport.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 27/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objective-zip/ZipWriteStream.h>
#import "DataExport.h"
#import "Constants.h"
#import "ZipFile.h"
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

    ZipFile *zipFile = [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeCreate];
    [self appendFileNamed:SmartReceiptsDatabaseName inDirectory:self.workDirectory archiveName:SmartReceiptsDatabaseExportName toZip:zipFile];
    [self appendAllTripFilesToZip:zipFile];
    NSData *preferences = [[WBPreferences xmlString] dataUsingEncoding:NSUTF8StringEncoding];
    [self appendData:preferences zipName:SmartReceiptsPreferencesExportName toFile:zipFile];
    [zipFile close];

    return zipPath;
}

- (void)appendData:(NSData *)data zipName:(NSString *)zipName toFile:(ZipFile *)zipFile {
    ZipWriteStream *stream = [zipFile writeFileInZipWithName:zipName compressionLevel:ZipCompressionLevelDefault];
    [stream writeData:data];
    [stream finishedWriting];
}

- (void)appendAllTripFilesToZip:(ZipFile *)file {
    NSString *tripsFolder = [self.workDirectory stringByAppendingPathComponent:SmartReceiptsTripsDirectoryName];
    NSArray *trips = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tripsFolder error:nil];
    for (NSString *trip in trips) {
        [self appFilesForTrip:trip toZip:file];
    }
}

- (void)appFilesForTrip:(NSString *)trip toZip:(ZipFile *)zip {
    NSString *tripFolder = [[self.workDirectory stringByAppendingPathComponent:SmartReceiptsTripsDirectoryName] stringByAppendingPathComponent:trip];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tripFolder error:nil];
    for (NSString *file in files) {
        NSString *zipName = [[SmartReceiptsTripsDirectoryName stringByAppendingPathComponent:trip] stringByAppendingPathComponent:file];
        [self appendFileNamed:file inDirectory:tripFolder archiveName:zipName toZip:zip];
    }
}

- (void)appendFileNamed:(NSString *)fileName inDirectory:(NSString *)containingDirectory archiveName:(NSString *)archiveName toZip:(ZipFile *)zipFile {
    NSString *filePath = [containingDirectory stringByAppendingPathComponent:fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [self appendData:fileData zipName:archiveName toFile:zipFile];
}

@end
