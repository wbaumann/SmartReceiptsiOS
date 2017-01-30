//
//  Database+Purchases.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Purchases.h"
#import "Constants.h"
#import "RMAppReceipt.h"
#import "NSDate+Calculations.h"
#import "RMStore.h"
#import "SmartReceipts-Swift.h"

@implementation Database (Purchases)

- (NSDate *)subscriptionEndDate {
    if (![Tweaker usePurchaseOverride]) {
        // One year in the future will be the expiration
        RMAppReceiptIAP *receiptForSubscription = [self receiptForSubscription];
        if (receiptForSubscription) {
            return [self oneYearFrom:receiptForSubscription.originalPurchaseDate];
        } else {
            return nil;
        }
    }

    if ([Tweaker subscriptionOverrideValue]) {
        return [NSDate distantFuture];
    }
    
    return [NSDate distantPast];
}

- (BOOL)hasValidSubscription {
    NSDate *endDate = [self subscriptionEndDate];
    return endDate != nil && [[NSDate date] isBeforeDate:endDate];
}

- (void)checkReceiptValidity {
    LOGGER_DEBUG(@"checkReceiptValidity");
    if ([self hasValidSubscription]) {
        LOGGER_INFO(@"Have valid subscription");
        return;
    }

    RMAppReceiptIAP *receiptIAP = [self receiptForSubscription];
    if (!receiptIAP) {
        LOGGER_DEBUG(@"No receipt");
        return;
    }

    NSString *identifier = receiptIAP.transactionIdentifier;
    if ([self haveRefreshedSubscriptionReceipt:receiptIAP]) {
        LOGGER_DEBUG(@"Already attempted refresh of this receipt");
        return;
    }

    LOGGER_DEBUG(@"Refresh");
    [[RMStore defaultStore] refreshReceiptOnSuccess:^{
        LOGGER_DEBUG(@"refreshReceiptOnSuccess");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsAdsRemovedNotification object:nil];
        });
    } failure:^(NSError *error) {
        LOGGER_ERROR(@"refreshReceipFailure:%@", error);
    }];
}

- (BOOL)haveRefreshedSubscriptionReceipt:(RMAppReceiptIAP *)receipt {
    NSString *transactionIdentifier = receipt.transactionIdentifier;
    return [[NSUserDefaults standardUserDefaults] boolForKey:transactionIdentifier];
}

- (RMAppReceiptIAP *)receiptForSubscription {
    RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
    LOGGER_DEBUG(@"");
    LOGGER_DEBUG(@"receipt:%@", receipt);
    LOGGER_DEBUG(@"%tu IAP-s", receipt.inAppPurchases.count);
    RMAppReceiptIAP *latest;
    for (RMAppReceiptIAP *receiptIAP in receipt.inAppPurchases) {
        LOGGER_DEBUG(@"IAP receipt:%@", receiptIAP);
        LOGGER_DEBUG(@"Purchase: %@", receiptIAP.purchaseDate);
        LOGGER_DEBUG(@"Original urchase: %@", receiptIAP.originalPurchaseDate);
        LOGGER_DEBUG(@"Expire: %@", receiptIAP.subscriptionExpirationDate);
        if (![receiptIAP.productIdentifier isEqualToString:SmartReceiptSubscriptionIAPIdentifier]) {
            continue;
        }
        
        if (!latest) {
            latest = receiptIAP;
            continue;
        }
        
        NSDate *known = latest.originalPurchaseDate;
        NSDate *checked = receiptIAP.originalPurchaseDate;
        if ([checked isAfterDate:known]) {
            latest = receiptIAP;
        }
    }

    return latest;
}

- (NSDate *)oneYearFrom: (NSDate *)date {
    NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:1];
    return [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
}

@end
