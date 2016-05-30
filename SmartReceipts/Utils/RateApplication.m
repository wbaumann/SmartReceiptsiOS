//
//  RateApplication.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import "RateApplication.h"
#import "Constants.h"
#import "NSDate+Calculations.h"

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
    RIButtonItem *negativeItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"rate.app.alert.negative.button", nil) action:^{
        [self markNoPressed];
    }];
    RIButtonItem *positiveItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"rate.app.alert.positive.button", nil) action:^{
        [self markRatePressed];

        NSString *templateReviewURL = @"itms-apps://itunes.apple.com/app/idAPP_ID";
        NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:SmartReceiptAppStoreId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
    }];
    RIButtonItem *neutralItem = [RIButtonItem itemWithLabel:NSLocalizedString(@"rate.app.alert.neutral.button", nil) action:^{
        [self rateLater];
    }];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"rate.app.alert.title", nil)
                                                        message:NSLocalizedString(@"rate.app.alert.message", nil)
                                               cancelButtonItem:negativeItem otherButtonItems:positiveItem, neutralItem, nil];
    [alertView show];
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
