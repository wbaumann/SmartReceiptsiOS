//
//  ReceiptColumnTax.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnTax.h"
#import "WBReceipt.h"

@implementation ReceiptColumnTax

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    if (forCSV) {
        return [receipt taxAsString];
    }

    return [receipt taxWithCurrencyFormatted];
}

@end
