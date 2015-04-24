//
//  ReceiptUnknownColumn.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptUnknownColumn.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptUnknownColumn

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip forCSV:(BOOL)forCSV {
    return NSStringFromClass(self.class);
}

@end
