//
//  Constants.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 22/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject;

#define ABSTRACT_METHOD \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] \
                                 userInfo:nil];

// Measuring execution time. TOCK returns an NSString with seconds
#define TICK NSDate *startTime = [NSDate date]
#define TOCK [NSString stringWithFormat: @"%f", -[startTime timeIntervalSinceNow]]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

extern NSString *const SmartReceiptsDatabaseName;
extern NSString *const SmartReceiptsTripsDirectoryName;
extern NSString *const SmartReceiptsExportName;
extern NSString *const SmartReceiptsDatabaseExportName;
extern NSString *const SmartReceiptsPreferencesExportName;
extern NSString *const SmartReceiptsPreferencesImportedNotification;
extern NSString *const SmartReceiptsDatabaseBulkUpdateNotification;
extern NSString *const SmartReceiptsSettingsSavedNotification;
extern NSString *const SmartReceiptsAdsRemovedNotification;
extern NSString *const SmartReceiptsImportNotification;

static NSUInteger const SmartReceiptsNumberOfDecimalPlacesForGasRate = 3;
static NSUInteger const SmartReceiptTargetLaunchesForAppRating = 15;
static NSUInteger const SmartReceiptDelayedLaunchesOnAppRatingLater = 10;
static NSUInteger const SmartReceiptMinUsageDaysForRating = 7;

static NSInteger const SmartReceiptExchangeRateDecimalPlaces = 10;

extern NSString *const SmartReceiptAppStoreId;

extern NSString *const SmartReceiptSubscriptionIAPIdentifier;

extern NSString *const SRNoData;

typedef void (^ActionBlock)();

void SRDelayedExecution(NSTimeInterval seconds, ActionBlock action);

#pragma mark - Feedback constants

extern NSString *const FeedbackEmailAddress;
extern NSString *const FeedbackEmailSubject;
extern NSString *const FeedbackBugreportEmailSubject;
