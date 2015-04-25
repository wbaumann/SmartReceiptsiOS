//
//  ReceiptColumnPrice.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnPrice.h"
#import "WBReceipt.h"

@implementation ReceiptColumnPrice

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    //TODO jaanus: price has if(forCSV) and tax does not?
    if (forCSV) {
        return [receipt priceAsString];
    }
    return [receipt priceWithCurrencyFormatted];
}

@end
