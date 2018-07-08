//
//  RateApplication.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "RateApplication.h"
#import "Constants.h"
#import "NSDate+Calculations.h"
#import "SmartReceipts-Swift.h"
#import <StoreKit/StoreKit.h>

static NSString *const SRRateAppCrashMarkerKey = @"SRRateAppCrashMarkerKey";
static NSString *const SRRateAppAppLaunchCountKey = @"SRRateAppAppLaunchCountKey";
static NSString *const SRRateAppFirstLaunchDateKey = @"SRRateAppFirstLaunchDateKey";
static NSString *const SRRateAppTargetLaunchesForRatingKey = @"SRRateAppTargetLaunchesForRatingKey";
static NSString *const SRRateAppNoPressedKey = @"SRRateAppNoPressedKey";
static NSString *const SRRateAppRatePressedKey = @"SRRateAppRatePressedKey";

@interface RateApplication ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation RateApplication

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (id)initSingleton {
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        if ([self.defaults integerForKey:SRRateAppTargetLaunchesForRatingKey] == 0) {
            [self.defaults setInteger:SmartReceiptTargetLaunchesForAppRating forKey:SRRateAppTargetLaunchesForRatingKey];
            [self.defaults synchronize];
        }
    }
    return self;
}

- (void)markAppLaunch {
    NSInteger launchCount = [self.defaults integerForKey:SRRateAppAppLaunchCountKey];
    launchCount = launchCount + 1;
    [self.defaults setInteger:launchCount forKey:SRRateAppAppLaunchCountKey];

    if (![self.defaults objectForKey:SRRateAppFirstLaunchDateKey]) {
        [self.defaults setObject:[NSDate date] forKey:SRRateAppFirstLaunchDateKey];
    }

    [self.defaults synchronize];

    if ([self shouldShowRateDialog]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertDialog];
        });
    }
}

- (void)showAlertDialog {
    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){10,3,0}]) {
        [SKStoreReviewController requestReview];
    } else {
        NSString *title = NSLocalizedString(@"rate.app.alert.title", nil);
        NSString *message = NSLocalizedString(@"rate.app.alert.message", nil);
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
        
        UIAlertAction *postitive = [UIAlertAction actionWithTitle:NSLocalizedString(@"rate.app.alert.positive.button", nil)
          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self markRatePressed];
              [[AnalyticsManager sharedManager] recordWithEvent:[Event ratingsUserSelectedRate]];

              NSMutableString *reviewURL = [@"itms-apps://itunes.apple.com/app/id" mutableCopy];
              [reviewURL appendString:SmartReceiptAppStoreId];
              [UIApplication.sharedApplication openURL:[NSURL URLWithString:reviewURL] options:@{} completionHandler:nil];
         }];
        
        UIAlertAction *negative = [UIAlertAction actionWithTitle:NSLocalizedString(@"rate.app.alert.negative.button", nil)
          style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
              [self markNoPressed];
              [[AnalyticsManager sharedManager] recordWithEvent:[Event ratingsUserSelectedNever]];
          }];
        
        UIAlertAction *neutral = [UIAlertAction actionWithTitle:NSLocalizedString(@"rate.app.alert.neutral.button", nil)
          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              [self rateLater];
              [[AnalyticsManager sharedManager] recordWithEvent:[Event ratingsUserSelectedLater]];
          }];
        
        [actionSheet addAction:postitive];
        [actionSheet addAction:neutral];
        [actionSheet addAction:negative];
        
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:actionSheet animated:YES completion:nil];
    
        [[AnalyticsManager sharedManager] recordWithEvent:[Event ratingsRatingPromptShown]];
    }
}

- (void)markAppCrash {
    [self.defaults setBool:YES forKey:SRRateAppCrashMarkerKey];
}

- (void)rateLater {
    NSInteger target = [self.defaults integerForKey:SRRateAppTargetLaunchesForRatingKey];
    target += SmartReceiptDelayedLaunchesOnAppRatingLater;
    [self.defaults setInteger:target forKey:SRRateAppTargetLaunchesForRatingKey];
    [self.defaults synchronize];
}

- (BOOL)shouldShowRateDialog {
    if ([self.defaults boolForKey:SRRateAppCrashMarkerKey]) {
        return NO;
    }

    if ([self.defaults boolForKey:SRRateAppRatePressedKey]) {
        return NO;
    }

    if ([self.defaults boolForKey:SRRateAppNoPressedKey]) {
        return NO;
    }

    if ([self launchCount] < [self launchTarget]) {
        return NO;
    }

    NSDate *date = [self firstLaunchDate];
    NSDate *now = [NSDate date];
    NSDate *requiredDaysSinceFirstLaunch = [date dateByAddingDays:SmartReceiptMinUsageDaysForRating];

    return [[requiredDaysSinceFirstLaunch laterDate:now] isOnSameDate:now];
}

- (void)markRatePressed {
    [self.defaults setBool:YES forKey:SRRateAppRatePressedKey];
}

- (void)markNoPressed {
    [self.defaults setBool:YES forKey:SRRateAppNoPressedKey];
}

- (NSInteger)launchCount {
    return [self.defaults integerForKey:SRRateAppAppLaunchCountKey];
}

- (NSInteger)launchTarget {
    return [self.defaults integerForKey:SRRateAppTargetLaunchesForRatingKey];
}

- (NSDate *)firstLaunchDate {
    return [self.defaults objectForKey:SRRateAppFirstLaunchDateKey];
}

#if DEBUG
- (void)reset {
    [self.defaults removeObjectForKey:SRRateAppCrashMarkerKey];
    [self.defaults removeObjectForKey:SRRateAppAppLaunchCountKey];
    [self.defaults removeObjectForKey:SRRateAppFirstLaunchDateKey];
    [self.defaults removeObjectForKey:SRRateAppRatePressedKey];
    [self.defaults removeObjectForKey:SRRateAppNoPressedKey];
    [self.defaults setInteger:SmartReceiptTargetLaunchesForAppRating forKey:SRRateAppTargetLaunchesForRatingKey];
    [self.defaults synchronize];
}

- (void)setLaunchCount:(NSUInteger)count {
    [self.defaults setInteger:count forKey:SRRateAppAppLaunchCountKey];
    [self.defaults synchronize];
}

- (void)setFirstLaunchDate:(NSDate *)date {
    [self.defaults setObject:date forKey:SRRateAppFirstLaunchDateKey];
    [self.defaults synchronize];
}
#endif

@end
