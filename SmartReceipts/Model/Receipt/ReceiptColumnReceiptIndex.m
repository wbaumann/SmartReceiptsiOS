//
//  ReceiptColumnReceiptIndex.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnReceiptIndex.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnReceiptIndex

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [NSString stringWithFormat:@"%d", receiptIndex];
}

@end
