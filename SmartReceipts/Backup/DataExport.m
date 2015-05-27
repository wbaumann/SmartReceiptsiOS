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
    [zipFile close];

    return zipPath;
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
        NSString *filePath = [tripFolder stringByAppendingPathComponent:file];
        NSString *zipName = [[SmartReceiptsTripsDirectoryName stringByAppendingPathComponent:trip] stringByAppendingPathComponent:file];
        [self appendFileNamed:file inDirectory:filePath archiveName:zipName toZip:zip];
    }
}

- (void)appendFileNamed:(NSString *)fileName inDirectory:(NSString *)containingDirectory archiveName:(NSString *)archiveName toZip:(ZipFile *)zipFile {
    NSString *filePath = [containingDirectory stringByAppendingPathComponent:fileName];
    ZipWriteStream *stream = [zipFile writeFileInZipWithName:archiveName compressionLevel:ZipCompressionLevelDefault];
    [stream writeData:[NSData dataWithContentsOfFile:filePath]];
    [stream finishedWriting];
}

@end
