//
//  WBAppDelegate.m
//  SmartReceipts
//
//  Created on 11/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBAppDelegate.h"

#import "PendingHUDView.h"
#import "Constants.h"
#import "Database+Import.h"
#import "RateApplication.h"
#import "RMStore.h"
#import "RMStoreKeychainPersistence.h"
#import "RMStoreAppReceiptVerificator.h"
#import "Database+Purchases.h"
#import "PrettyPDFRender.h"

#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "Tweaks/FBTweakShakeWindow.h"
#import <SmartReceipts-Swift.h>

#import <FirebaseCore/FirebaseCore.h>
#import <FirebaseCrash/FirebaseCrash.h>

@interface WBAppDelegate ()

@property (nonatomic, strong) RMStoreAppReceiptVerificator *receiptVerificator;
@property (nonatomic, strong) RMStoreKeychainPersistence *keychainPersistence;

@end

@implementation WBAppDelegate {
    dispatch_queue_t _queue;
}

#if DEBUG
- (UIWindow *)window {
    if (!_window) {
        _window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    
    return _window;
}

- (void)tweakUIDismissed {
    LOGGER_DEBUG(@"tweakUIDismissed");
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for AppTheme after application launch.
    
    [FIRApp configure];
    
    [self enableAnalytics];
    
    _queue = dispatch_queue_create("wb.dataAccess", nil);

    [AppTheme customizeOnAppLoad];

    RMStoreAppReceiptVerificator *verificator = [[RMStoreAppReceiptVerificator alloc] init];
    [self setReceiptVerificator:verificator];
    [[RMStore defaultStore] setReceiptVerificator:verificator];
    RMStoreKeychainPersistence *persistor = [[RMStoreKeychainPersistence alloc] init];
    [self setKeychainPersistence:persistor];
    [[RMStore defaultStore] setTransactionPersistor:persistor];

    __unused BOOL hasTripsDir = [NSFileManager initTripsDirectory];
    [[Database sharedInstance] open];

    [[Database sharedInstance] checkReceiptValidity];
    
    // update recently used currencies list on app launch
    [[RecentCurrenciesCache shared] update];

    NSString *language = [NSLocale preferredLanguages][0];
    LOGGER_INFO(@"lang: %@", language);

    NSSetUncaughtExceptionHandler(&onUncaughtExcepetion);

    [[RateApplication sharedInstance] markAppLaunch];
    
    [Tweaker preload];
    
#if DEBUG
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweakUIDismissed) name:FBTweakShakeViewControllerDidDismissNotification object:nil];
#endif
    
    LOGGER_INFO(@"Application didFinishLaunchingWithOptions: %@", launchOptions);
    
    return YES;
}

void onUncaughtExcepetion(NSException *exception) {
    [[RateApplication sharedInstance] markAppCrash];
    
    // Log exception
    NSMutableString *message = [NSMutableString new];
    [message appendString:exception.description];
    [message appendString:@"\n"];
    [message appendString:exception.callStackSymbols.description];
    [Logger error:message file:@"UncaughtExcepetion" function:@"onUncaughtExcepetion" line:0];
    
    FIRCrashLog(@"%@", message);
    
    // record analytics event too
    ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithException:exception];
    [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
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

#pragma mark openURL delegate methods:

/// For iOS 9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url isFileURL]) {
        [self handleOpenURL:url];
    }
    return YES;
}

/// For iOS 8 compability
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url isFileURL]) {
        [self handleOpenURL:url];
    }
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    LOGGER_WARNING(@"applicationDidReceiveMemoryWarning");
}

#pragma mark - custom methods

+ (WBAppDelegate *)instance {
    return (WBAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (dispatch_queue_t)dataQueue {
    return _queue;
}

- (void)freeFilePathToAttach {
    [NSFileManager deleteIfExistsWithFilepath:self.filePathToAttach];
    self.filePathToAttach = nil;
}

- (void)handleOpenURL:(NSURL *)url {
    
    if ([WBAppDelegate isStringIgnoreCase:url.pathExtension inArray:@[@"png", @"jpg", @"jpeg"]]) {
        LOGGER_INFO(@"Launched for image");
        self.isFileImage = YES;
        [self handlePdfOrImage:url];
    } else if ([url.pathExtension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
        LOGGER_INFO(@"Launched for pdf");
        self.isFileImage = NO;
        [self handlePdfOrImage:url];
    } else if ([url.pathExtension caseInsensitiveCompare:@"smr"] == NSOrderedSame) {
        LOGGER_INFO(@"Launched for smr");
        [self handleSMR:url];
    } else {
        LOGGER_INFO(@"Loaded with unknown file");
    }

}

- (void)handlePdfOrImage:(NSURL *)url {

    NSString *path = [url path];
    if ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:([path length] - 1)];
    }

    self.filePathToAttach = path;

    if (self.isFileImage) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"app.delegate.attach.image.alert.title", nil)
                                    message:NSLocalizedString(@"app.delegate.attach.image.alert.message", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil)
                          otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"app.delegate.attach.pdf.alert.title", nil)
                                    message:NSLocalizedString(@"app.delegate.attach.pdf.alert.message", nil)
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil)
                          otherButtonTitles:nil] show];
    }

}

- (void)handleSMR:(NSURL *)url {
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"app.delegate.import.alert.title", nil)
                                message:NSLocalizedString(@"app.delegate.import.alert.message", nil)
                       cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.cancel", nil) action:^{
                           [NSFileManager deleteIfExistsWithFilepath:[url path]];
                       }]
                       otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.yes", nil) action:^{ [self importZipFrom:url overwrite:YES]; }],
                                        [RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.no", nil) action:^{ [self importZipFrom:url overwrite:NO]; }], nil] show];
}

- (void)importZipFrom:(NSURL *)zipPath overwrite:(BOOL)overwrite {
    PendingHUDView *hud = [PendingHUDView showHUDOnView:self.window.rootViewController.view];
    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
        DataImport *dataImport = [[DataImport alloc] initWithInputFile:zipPath.path output:[NSFileManager documentsPath]];
        
        BOOL success = YES; // true by default
        
        @try {
            [dataImport execute];
        } @catch (NSException *exception) {
            success = NO;
            LOGGER_ERROR(@"importZip error: %@", [exception reason]);
            ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithException:exception];
            [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        }
        
        if (success) {
            // delete imported zip and import data to DB
            [NSFileManager deleteIfExistsWithFilepath:[zipPath path]];
            id backupPath = [NSFileManager pathInDocumentsWithRelativePath:SmartReceiptsDatabaseExportName];
            success = [[Database sharedInstance] importDataFromBackup:backupPath overwrite:overwrite];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

            if (success) {
                [[[UIAlertView alloc]
                        initWithTitle:nil
                              message:NSLocalizedString(@"app.delegate.import.success.alert.message", nil)
                             delegate:nil
                    cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil)
                    otherButtonTitles:nil] show];
                LOGGER_INFO(@"app.delegate.import.success");
            } else {
                [[[UIAlertView alloc]
                        initWithTitle:NSLocalizedString(@"generic.error.alert.title", nil)
                              message:NSLocalizedString(@"app.delegate.import.error.alert.message", nil)
                             delegate:nil
                    cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil)
                    otherButtonTitles:nil] show];
                LOGGER_ERROR(@"app.delegate.import.error");
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
