//
//  ReceiptColumnReportStartDate.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnReportStartDate.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "WBDateFormatter.h"

@implementation ReceiptColumnReportStartDate

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [self.dateFormatter formattedDate:[trip startDate] inTimeZone:[trip startTimeZone]];
}

@end
