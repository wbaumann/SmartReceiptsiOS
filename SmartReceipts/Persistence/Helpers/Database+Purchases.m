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

@implementation Database (Purchases)

- (NSDate *)subscriptionEndDate {
    RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
    SRLog(@"receipt:%@", receipt);
    for (RMAppReceiptIAP *receiptIAP in receipt.inAppPurchases) {
        SRLog(@"receipt:%@", receiptIAP);
        if ([receiptIAP.productIdentifier isEqualToString:SmartReceiptSubscriptionIAPIdentifier]) {
            return receiptIAP.subscriptionExpirationDate;
        }
    }

    return nil;
}

- (BOOL)hasValidSubscription {
    NSDate *endDate = [self subscriptionEndDate];
    SRLog(@"subscription end date:%@", endDate);
    return endDate != nil && [[NSDate date] isBeforeDate:endDate];
}

@end
