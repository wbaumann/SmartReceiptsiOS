//
//  WBFileManager.m
//  SmartReceipts
//
//  Created on 28/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBFileManager.h"
#import "Constants.h"

@implementation WBFileManager

+(NSString*) documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    LOGGER_INFO(@"documentsPaths: %@", paths);
    return [paths objectAtIndex:0];
}

+(NSString*) pathInDocuments:(NSString*) relativePath {
    return [[WBFileManager documentsPath] stringByAppendingPathComponent:relativePath];
}

+(BOOL) pathInDocumentsExists:(NSString*) filePath{
    return [[NSFileManager defaultManager] fileExistsAtPath:[WBFileManager pathInDocuments:filePath]];
}

+(NSString*) tripsDirectoryPath {
    return [WBFileManager pathInDocuments:SmartReceiptsTripsDirectoryName];
}

+(BOOL) initTripsDirectory {
    NSString *path = [WBFileManager tripsDirectoryPath];
    return [WBFileManager createDirectoryIfNotExists:path];
}

+(BOOL) createDirectoryIfNotExists:(NSString*) path {
    NSError *error;
    if([[NSFileManager defaultManager] createDirectoryAtPath:path
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error]){
        return true;
    } else {
        LOGGER_ERROR(@"Couldn't create directory: %@", [error localizedDescription]);
        return false;
    }
}

+(void) prepareDirForForceFile:(NSString*) newFile {
    if ([[NSFileManager defaultManager] fileExistsAtPath:newFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:newFile error:nil];
    }
    
    NSString *dir = [newFile stringByDeletingLastPathComponent];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError *error;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:dir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error]){
            LOGGER_ERROR(@"Couldn't create directory: %@", [error localizedDescription]);
        }
    }
}

+(void) deleteIfExists:(NSString*) filepath {
    if (!filepath) {
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
    }
}

+(BOOL) forceWriteData:(NSData*) data to:(NSString*) newFile {
    [WBFileManager prepareDirForForceFile:newFile];
    
    if (![data writeToFile:newFile atomically:YES]) {
        LOGGER_ERROR(@"Failed to write data to file");
        return false;
    }
    
    return true;
}

+(BOOL) forceCopyFrom:(NSString*) oldFile to:(NSString*) newFile {
    [WBFileManager prepareDirForForceFile:newFile];
    
    if(![[NSFileManager defaultManager] copyItemAtPath:oldFile toPath:newFile error:nil]){
        LOGGER_ERROR(@"Failed to copy file");
        return false;
    }
    
    return true;
}

@end
