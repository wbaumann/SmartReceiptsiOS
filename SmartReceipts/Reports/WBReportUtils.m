//
//  WBReportUtils.m
//  SmartReceipts
//
//  Created on 04/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReportUtils.h"
#import "WBPreferences.h"

@implementation WBReportUtils

+ (BOOL)filterOutReceipt:(WBReceipt *)receipt {
    if ([WBPreferences onlyIncludeReimbursableReceiptsInReports] && ![receipt isReimbursable]) {
        return YES;
    }
    else if ([[receipt priceAmount] compare:[[NSDecimalNumber alloc] initWithFloat:[WBPreferences minimumReceiptPriceToIncludeInReports]]] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
