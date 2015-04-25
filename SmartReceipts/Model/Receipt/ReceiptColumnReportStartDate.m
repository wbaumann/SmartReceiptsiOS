//
//  ReceiptColumnReportStartDate.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnReportStartDate.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "WBDateFormatter.h"

@implementation ReceiptColumnReportStartDate

- (NSString *)valueFromReceipt:(WBReceipt *)receipt receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [self.dateFormatter formattedDate:[receipt.trip startDate] inTimeZone:[receipt.trip startTimeZone]];
}

@end
