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
        RMAppReceiptIAP *receiptForSubscription = [self receiptForSubscription];
        return [receiptForSubscription.originalPurchaseDate dateByAddingDays:365];
    }

    if ([Tweaker subscriptionOverrideValue]) {
        return [NSDate distantFuture];
    }
    
    return [NSDate distantPast];
}

- (BOOL)hasValidSubscription {
    NSDate *endDate = [self subscriptionEndDate];
    SRLog(@"subscription end date:%@", endDate);
    return endDate != nil && [[NSDate date] isBeforeDate:endDate];
}

- (void)checkReceiptValidity {
    SRLog(@"checkReceiptValidity");
    if ([self hasValidSubscription]) {
        SRLog(@"Have valid subscription");
        return;
    }

    RMAppReceiptIAP *receiptIAP = [self receiptForSubscription];
    if (!receiptIAP) {
        SRLog(@"No receipt");
        return;
    }

    NSString *identifier = receiptIAP.transactionIdentifier;
    if ([self haveRefreshedSubscriptionReceipt:receiptIAP]) {
        SRLog(@"Already attempted refresh of this receipt");
        return;
    }

    SRLog(@"Refresh");
    [[RMStore defaultStore] refreshReceiptOnSuccess:^{
        SRLog(@"refreshReceiptOnSuccess");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsAdsRemovedNotification object:nil];
        });
    } failure:^(NSError *error) {
        SRLog(@"refreshReceipFailure:%@", error);
    }];
}

- (BOOL)haveRefreshedSubscriptionReceipt:(RMAppReceiptIAP *)receipt {
    NSString *transactionIdentifier = receipt.transactionIdentifier;
    return [[NSUserDefaults standardUserDefaults] boolForKey:transactionIdentifier];
}

- (RMAppReceiptIAP *)receiptForSubscription {
    RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
    SRLog(@"");
    SRLog(@"receipt:%@", receipt);
    SRLog(@"%tu IAP-s", receipt.inAppPurchases.count);
    RMAppReceiptIAP *latest;
    for (RMAppReceiptIAP *receiptIAP in receipt.inAppPurchases) {
        SRLog(@"IAP receipt:%@", receiptIAP);
        SRLog(@"Purchase: %@", receiptIAP.purchaseDate);
        SRLog(@"Original urchase: %@", receiptIAP.originalPurchaseDate);
        SRLog(@"Expire: %@", receiptIAP.subscriptionExpirationDate);
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

@end
