//
//  WBAppDelegate.m
//  SmartReceipts
//
//  Created on 11/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBAppDelegate.h"

#import "WBFileManager.h"

#import "WBCustomization.h"
#import "PendingHUDView.h"
#import "DataImport.h"
#import "Constants.h"
#import "Database+Import.h"

#import <BugSense-iOS/BugSenseController.h>
#import <UIAlertView-Blocks/RIButtonItem.h>
#import <UIAlertView-Blocks/UIAlertView+Blocks.h>

@implementation WBAppDelegate {
    dispatch_queue_t _queue;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _queue = dispatch_queue_create("wb.dataAccess", nil);

    [WBCustomization customizeOnAppLoad];

    [WBFileManager initTripsDirectory];
    [[Database sharedInstance] open];

    NSString *language = [NSLocale preferredLanguages][0];
    SRLog(@"lang: %@", language);

    NSURL *url = (NSURL *) [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url != nil && [url isFileURL]) {
        [self handleOpenURL:url];
    }

    [BugSenseController sharedControllerWithBugSenseAPIKey:@"c65e0389"];

    NSSetUncaughtExceptionHandler(&onUncaughtExcepetion);

    return YES;
}

void onUncaughtExcepetion(NSException *exception) {
    NSLog(@"Exception: %@", exception);
    NSLog(@"%@", [NSThread callStackSymbols]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    // nil to not show on next time, and delete file to save space
    [self freeFilePathToAttach];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [[Database sharedInstance] close];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // called when app was in background and was restored with url
    if (url != nil && [url isFileURL]) {
        [self handleOpenURL:url];
    }
    return YES;
}

#pragma mark - custom methods

+ (WBAppDelegate *)instance {
    return (WBAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (dispatch_queue_t)dataQueue {
    return _queue;
}

- (void)freeFilePathToAttach {
    [WBFileManager deleteIfExists:self.filePathToAttach];
    self.filePathToAttach = nil;
}

- (void)handleOpenURL:(NSURL *)url {

    if ([WBAppDelegate isStringIgnoreCase:url.pathExtension inArray:@[@"png", @"jpg", @"jpeg"]]) {
        NSLog(@"Launched for image");
        self.isFileImage = YES;
        [self handlePdfOrImage:url];
    } else if ([url.pathExtension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
        NSLog(@"Launched for pdf");
        self.isFileImage = NO;
        [self handlePdfOrImage:url];
    } else if ([url.pathExtension caseInsensitiveCompare:@"smr"] == NSOrderedSame) {
        NSLog(@"Launched for smr");
        [self handleSMR:url];
    } else {
        NSLog(@"Loaded with unknown file");
    }

}

- (void)handlePdfOrImage:(NSURL *)url {

    NSString *path = [url path];
    if ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:([path length] - 1)];
    }

    self.filePathToAttach = path;

    if (self.isFileImage) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attach Image", nil)
                                    message:NSLocalizedString(@"Tap on an existing receipt to add this Image to it", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attach PDF", nil)
                                    message:NSLocalizedString(@"Tap on an existing receipt to add this PDF to it", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }

}

- (void)handleSMR:(NSURL *)url {

    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Import", nil)
                                message:NSLocalizedString(@"Overwrite Existing Data?", nil)
                       cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", nil) action:^{
                           [WBFileManager deleteIfExists:[url path]];
                       }]
                       otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"Yes", nil) action:^{ [self importZipFrom:url overwrite:YES]; }],
                                        [RIButtonItem itemWithLabel:NSLocalizedString(@"No", nil) action:^{ [self importZipFrom:url overwrite:NO]; }], nil] show];
}

- (void)importZipFrom:(NSURL *)zipPath overwrite:(BOOL)overwrite {
    PendingHUDView *hud = [PendingHUDView showHUDOnView:self.window.rootViewController.view];
    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
        DataImport *dataImport = [[DataImport alloc] initWithInputFile:zipPath.path output:[WBFileManager documentsPath]];
        [dataImport execute];

        // delete imported zip
        [WBFileManager deleteIfExists:[zipPath path]];
        BOOL result = [[Database sharedInstance] importDataFromBackup:[WBFileManager pathInDocuments:SmartReceiptsDatabaseExportName] overwrite:overwrite];

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

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

+ (BOOL)isStringIgnoreCase:(NSString *)str inArray:(NSArray *)arr {
    for (NSString *pe in arr) {
        if ([pe caseInsensitiveCompare:str] == NSOrderedSame) {
            return true;
        }
    }
    return false;
}

@end
