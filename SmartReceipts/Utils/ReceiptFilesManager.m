//
//  ReceiptFilesManager.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptFilesManager.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "Constants.h"

@interface ReceiptFilesManager ()

@property (nonatomic, copy) NSString *pathToTripsFolder;

@end

@implementation ReceiptFilesManager

- (id)initWithTripsFolder:(NSString *)pathToTripsFolder {
    if (self) {
        _pathToTripsFolder = pathToTripsFolder;
    }
    return self;
}

- (BOOL)saveImage:(UIImage *)image forReceipt:(WBReceipt *)receipt {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.85);
    NSString *path = [self pathForReceiptFile:receipt];
    [self ensureContainingFolderExists:path];
    NSError *writeError = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&writeError];
    if (writeError) {
        SRLog(@"Save image to %@ failed. Error:%@", path, writeError);
        return NO;
    }

    return YES;
}

- (BOOL)copyFileForReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    SRLog(@"copyFileForReceipt:%@", receipt);
    if (![self fileExistsForReceipt:receipt]) {
        return YES;
    }

    NSString *sourcePath = [self pathForReceiptFile:receipt];
    NSString *destinationPath = [self pathForReceiptFile:receipt withTrip:trip];
    [self ensureContainingFolderExists:destinationPath];
    NSError *copyError = nil;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&copyError];
    if (copyError) {
        SRLog(@"Copy from %@ to %@ failed. Error:%@", sourcePath, destinationPath, copyError);
        return NO;
    }

    return YES;
}

- (BOOL)moveFileForReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    SRLog(@"moveFileForReceipt:%@", receipt);
    if (![self fileExistsForReceipt:receipt]) {
        return YES;
    }

    NSString *sourcePath = [self pathForReceiptFile:receipt];
    NSString *destinationPath = [self pathForReceiptFile:receipt withTrip:trip];
    [self ensureContainingFolderExists:destinationPath];
    NSError *moveError = nil;
    SRLog(@"Move %@ to %@", sourcePath, destinationPath);
    [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:destinationPath error:&moveError];
    if (moveError) {
        SRLog(@"Move from %@ to %@ failed. Error:%@", sourcePath, destinationPath, moveError);
        return NO;
    }

    return YES;
}

- (BOOL)fileExistsForReceipt:(WBReceipt *)receipt {
    NSString *path = [self pathForReceiptFile:receipt];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString *)pathForReceiptFile:(WBReceipt *)receipt {
    return [self pathForReceiptFile:receipt withTrip:receipt.trip];
}

- (NSString *)pathForReceiptFile:(WBReceipt *)receipt withTrip:(WBTrip *)trip {
    NSString *tripFolder = [self.pathToTripsFolder stringByAppendingPathComponent:trip.name];
    NSString *filePath = [tripFolder stringByAppendingPathComponent:receipt.imageFileName];
    return filePath;
}

- (void)ensureContainingFolderExists:(NSString *)filePath {
    SRLog(@"Ensure folder for path:%@", filePath);
    NSString *folderPath = [filePath substringToIndex:filePath.length - [filePath lastPathComponent].length];
    SRLog(@"Folder path:%@", folderPath);
    NSError *createFolderError = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&createFolderError];
    if (createFolderError) {
        SRLog(@"ensureContainingFolderExists:%@", createFolderError);
    }
}

@end
