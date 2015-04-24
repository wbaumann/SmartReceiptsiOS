//
//  ReceiptColumnExpensable.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnExpensable.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnExpensable

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [receipt isExpensable] ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil);
}

@end
