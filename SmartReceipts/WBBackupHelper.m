//
//  WBBackupHelper.m
//  SmartReceipts
//
//  Created on 08/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBBackupHelper.h"

#import "WBFileManager.h"

#import "WBPreferences.h"
#import "WBDB.h"

#import "ZipFile.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"

#import "WBObservableTrips.h"

#import "WBTextUtils.h"
#import "HUD.h"

#import "WBAppDelegate.h"

#import "SettingsViewController.h"

NSString *DATABASE_EXPORT_NAME = @"receipts_backup.db";

@implementation WBBackupHelper
{
    NSURL *_url;
}

-(NSString*) exportAll {
    NSString *zipPath = [WBFileManager pathInDocuments:@"SmartReceipts.smr"];
    [WBFileManager deleteIfExists:zipPath];
    
    // DB file
    NSString *dbPath = [WBFileManager pathInDocuments:@"receipts.db"];
    ZipFile *zipFile = [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeCreate];
    {
        ZipWriteStream *stream = [zipFile writeFileInZipWithName:DATABASE_EXPORT_NAME compressionLevel:ZipCompressionLevelDefault];
        [stream writeData:[NSData dataWithContentsOfFile:dbPath]];
        [stream finishedWriting];
    }
    
    // trips contents
    NSString *tripsPath = [WBFileManager tripsDirectoryPath];
    NSArray *tripsDirectories = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tripsPath error:NULL];
    
    for (NSString *dirName in tripsDirectories) {
        @autoreleasepool {
            
            NSString *dirPath = [tripsPath stringByAppendingPathComponent:dirName];
            
            NSArray *receiptsFiles = [[NSFileManager defaultManager]
                                      contentsOfDirectoryAtPath:dirPath error:NULL];
            
            for (NSString *fileName in receiptsFiles) {
                NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
                NSString *pathInZip = [dirName stringByAppendingPathComponent:fileName];
                
                ZipWriteStream *stream = [zipFile writeFileInZipWithName:pathInZip compressionLevel:ZipCompressionLevelDefault];
                [stream writeData:[NSData dataWithContentsOfFile:filePath]];
                [stream finishedWriting];
            }
            
        }
    }
    
    // prefs
    @try {
        NSString *prefsPath = @"shared_prefs/SmartReceiptsPrefFile.xml";
        
        ZipWriteStream *stream = [zipFile writeFileInZipWithName:prefsPath compressionLevel:ZipCompressionLevelDefault];
        
        [stream writeData:[[WBPreferences xmlString] dataUsingEncoding:NSUTF8StringEncoding]];
        [stream finishedWriting];
    }
    @catch (NSException *exception) {
        NSLog(@"error while zipping prefs");
    }
    
    [zipFile close];
    return zipPath;
}

-(BOOL) importAllFrom:(NSString*) path overwrite:(BOOL) overwrite {
    ZipFile *zipFile = [[ZipFile alloc] initWithFileName:path mode:ZipFileModeUnzip];
    
    if ([zipFile numFilesInZip] <= 0) {
        // nothing to import
        return YES;
    }
    
    NSString *backupDbPath = [WBFileManager pathInDocuments:DATABASE_EXPORT_NAME];
    [WBFileManager deleteIfExists:backupDbPath];
    
     NSMutableData *buffer = [[NSMutableData alloc] initWithLength:(8*1024)];
    
    
    // DB file
    @try {
        if ([zipFile locateFileInZip:DATABASE_EXPORT_NAME]) {
            ZipReadStream *stream = [zipFile readCurrentFileInZip];
            
            NSMutableData *resultData = [[NSMutableData alloc] init];
            NSUInteger len;
            while ((len = [stream readDataWithBuffer:buffer]) > 0) {
                [resultData appendBytes:[buffer mutableBytes] length:len];
            }
            
            [stream finishedReading];
            
            if(![WBFileManager forceWriteData:resultData to:backupDbPath]){
                NSLog(@"couldn't write backup db");
                @throw [[NSException alloc] init];
            }
            
            if(![WBDB mergeWithDatabaseAtPath:backupDbPath overwrite:overwrite]){
                NSLog(@"couldn't merge db");
                return false;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error reading DB: %@", [exception reason]);
        return false;
    }

    // trips contents
    [zipFile goToFirstFileInZip];
    do {
        NSString *name = [[zipFile getCurrentFileInZipInfo] name];
        if ([name hasPrefix:DATABASE_EXPORT_NAME] ||
            [name hasPrefix:@"shared_prefs/"]) {
            continue;
        }
        
        NSArray *components = [name pathComponents];
        if (components.count != 2) {
            continue;
        }
        
        NSString *tripName = [components objectAtIndex:0];
        NSString *fileName = [components objectAtIndex:1];
        
        NSString *tripDir = [[WBFileManager tripsDirectoryPath] stringByAppendingPathComponent:tripName];
        [WBFileManager createDirectoryIfNotExists:tripDir];
        NSString *filePath = [tripDir stringByAppendingPathComponent:fileName];
        
        ZipReadStream *stream = [zipFile readCurrentFileInZip];
        NSMutableData *resultData = [[NSMutableData alloc] init];
        NSUInteger len;
        while ((len = [stream readDataWithBuffer:buffer]) > 0) {
            [resultData appendBytes:[buffer mutableBytes] length:len];
        }
        [stream finishedReading];
        
        [WBFileManager forceWriteData:resultData to:filePath];
    } while ([zipFile goToNextFileInZip]);
    
    // prefs
    @try {
        NSString *prefsPath = @"shared_prefs/SmartReceiptsPrefFile.xml";
        
        if ([zipFile locateFileInZip:prefsPath]) {
            NSLog(@"found prefs file");
            ZipReadStream *stream = [zipFile readCurrentFileInZip];
            NSMutableData *resultData = [[NSMutableData alloc] init];
            NSUInteger len;
            while ((len = [stream readDataWithBuffer:buffer]) > 0) {
                [resultData appendBytes:[buffer mutableBytes] length:len];
            }
            [stream finishedReading];
            
            NSString *xml = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            [WBPreferences setFromXmlString:xml];
        } else {
            NSLog(@"didn't find prefs file");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error while unzipping prefs: %@", [exception reason]);
    }
    
    [zipFile close];
    return YES;
}

-(void) handleImport:(NSURL*) url {
    _url = url;
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Import",nil)
                                message:NSLocalizedString(@"Overwrite Existing Data?",nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                      otherButtonTitles:NSLocalizedString(@"Yes",nil),NSLocalizedString(@"No",nil),nil
      ] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL overwrite = YES;
    switch (buttonIndex) {
        case 2:
            overwrite = NO;
            break;
            
        case 1:
            overwrite = YES;
            break;
            
        default:
            // delete zip, we are not going to use it
            [WBFileManager deleteIfExists:[_url path]];
            return;
    }
    
    [WBBackupHelper setDataBlocked:YES];
    [HUD showUIBlockingIndicatorWithText:NSLocalizedString(@"Importing ...", nil)];
    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
        BOOL result = NO;
        @try {
            result = [self importAllFrom:[_url path] overwrite:overwrite];
        } @catch (NSException *e) {
            result = NO;
        }
        
        // delete imported zip
        [WBFileManager deleteIfExists:[_url path]];
        
        NSArray *trips = [[WBDB trips] selectAll];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[WBObservableTrips lastInstance] setTrips:trips];
            [HUD hideUIBlockingIndicator];
            [WBBackupHelper setDataBlocked:NO];
            
            // refresh if visible
            [[SettingsViewController visibleInstance] populateValues];
            
            if (result) {
                [[[UIAlertView alloc]
                  initWithTitle:nil
                  message:NSLocalizedString(@"Successfully imported all files.", nil)
                  delegate:nil
                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                  otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc]
                  initWithTitle:NSLocalizedString(@"Error", nil)
                  message:NSLocalizedString(@"Failed to recognize the file as importable.", nil)
                  delegate:nil
                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                  otherButtonTitles:nil] show];
            }
            
        });
    });
}

static BOOL Blocked = NO;

+(BOOL) isDataBlocked {
    return Blocked;
}

+(void) setDataBlocked:(BOOL) blocked {
    
    
    
    Blocked = blocked;
}

@end
