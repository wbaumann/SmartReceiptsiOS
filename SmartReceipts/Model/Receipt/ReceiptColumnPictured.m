//
//  ReceiptColumnPictured.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnPictured.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnPictured

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    if ([receipt hasImage]) {
        return NSLocalizedString(@"receipt.column.pictured.value.yes", nil);
    } else if ([receipt hasPDF]) {
        return NSLocalizedString(@"receipt.column.pictured.value.pdf", nil);
    } else {
        return NSLocalizedString(@"receipt.column.pictured.value.no", nil);
    }
}

@end
