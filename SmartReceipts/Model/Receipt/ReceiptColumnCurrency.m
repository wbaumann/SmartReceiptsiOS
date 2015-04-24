//
//  ReceiptColumnCurrency.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnCurrency.h"
#import "WBReceipt.h"
#import "WBCurrency.h"

@implementation ReceiptColumnCurrency

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [[receipt currency] code];
}

@end
