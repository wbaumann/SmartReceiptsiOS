//
//  WBAppDelegate.m
//  SmartReceipts
//
//  Created on 11/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBAppDelegate.h"

#import "WBDB.h"
#import "WBFileManager.h"

#import "WBCustomization.h"
#import "WBFileManager.h"

#import "WBBackupHelper.h"

#import <BugSense-iOS/BugSenseController.h>

@implementation WBAppDelegate
{
    WBBackupHelper *_backupHelper;
    dispatch_queue_t _queue;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _queue = dispatch_queue_create("wb.dataAccess", nil);
    
    _backupHelper = [[WBBackupHelper alloc] init];
    
    [WBCustomization customizeOnAppLoad];
    
    [WBFileManager initTripsDirectory];
    [WBDB open];

    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"lang: %@", language);
    
    NSURL *url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    if (url != nil && [url isFileURL]) {
        [self handleOpenURL:url];
    }
    
    [BugSenseController sharedControllerWithBugSenseAPIKey:@"c65e0389"];
    
    NSSetUncaughtExceptionHandler(&onUncaughtExcepetion);
    
    return YES;
}

void onUncaughtExcepetion(NSException* exception)
{
    NSLog(@"Exception: %@", exception);
    NSLog(@"%@",[NSThread callStackSymbols]);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // nil to not show on next time, and delete file to save space
    [self freeFilePathToAttach];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [WBDB close];
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
    return (WBAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (dispatch_queue_t) dataQueue {
    return _queue;
}

- (void) freeFilePathToAttach {
    [WBFileManager deleteIfExists:self.filePathToAttach];
    self.filePathToAttach = nil;
}

- (void)handleOpenURL:(NSURL *)url {
    
    if ([WBAppDelegate isStringIgnoreCase:url.pathExtension inArray:@[@"png",@"jpg",@"jpeg"]]) {
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

- (void)handlePdfOrImage:(NSURL*) url {
    
    NSString* path = [url path];
    if ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:([path length] - 1)];
    }
    
    self.filePathToAttach = path;
    
    if (self.isFileImage) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attach Image",nil)
                                    message:NSLocalizedString(@"Tap on an existing receipt to add this Image to it",nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK",nil)
                          otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Attach PDF",nil)
                                    message:NSLocalizedString(@"Tap on an existing receipt to add this PDF to it",nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK",nil)
                          otherButtonTitles:nil] show];
    }
    
}

- (void)handleSMR:(NSURL*) url {
    [_backupHelper handleImport:url];
}

+(BOOL)isStringIgnoreCase:(NSString *) str inArray:(NSArray*) arr {
    for (NSString* pe in arr) {
        if ([pe caseInsensitiveCompare:str]==NSOrderedSame) {
            return true;
        }
    }
    return false;
}

@end
