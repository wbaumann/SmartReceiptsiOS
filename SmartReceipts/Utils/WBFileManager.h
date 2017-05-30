//
//  WBFileManager.h
//  SmartReceipts
//
//  Created on 28/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBFileManager : NSObject

+(NSString*) documentsPath;

+(NSString*) pathInDocuments:(NSString*) relativePath;

+(BOOL) pathInDocumentsExists:(NSString*) filePath;

+(NSString*) tripsDirectoryPath;

+(BOOL) initTripsDirectory;

+(void) deleteIfExists:(NSString*) filepath;

+(BOOL) createDirectoryIfNotExists:(NSString*) path;

+(BOOL) forceWriteData:(NSData*) data to:(NSString*) newFile;

+(BOOL) forceCopyFrom:(NSString*) oldFile to:(NSString*) newFile;

@end
