//
//  Database+Purchases.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <RMStore/RMStoreKeychainPersistence.h>
#import "Database+Purchases.h"
#import "RMStore.h"
#import "Constants.h"

@implementation Database (Purchases)

- (BOOL)adsRemoved {
    return [((RMStoreKeychainPersistence *)[RMStore defaultStore].transactionPersistor) isPurchasedProductOfIdentifier:SmartReceiptRemoveAdsIAPIdentifier];
}

@end
