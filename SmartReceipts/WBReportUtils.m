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

+(BOOL) filterOutReceipt:(WBReceipt*) receipt {
    if ([WBPreferences onlyIncludeExpensableReceiptsInReports] && ![receipt isExpensable]) {
        return true;
    }
    else if ([receipt priceAmount] < [[NSDecimalNumber alloc] initWithFloat:[WBPreferences minimumReceiptPriceToIncludeInReports]]) {
        return true;
    }
    else {
        return false;
    }
}

@end
