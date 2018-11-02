//
//  ReceiptColumnUserID.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnUserID.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "WBPreferences.h"

@implementation ReceiptColumnUserID

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [WBPreferences userID];
}

@end
