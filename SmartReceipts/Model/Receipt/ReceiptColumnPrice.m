//
//  ReceiptColumnPrice.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnPrice.h"
#import "WBReceipt.h"
#import "SmartReceipts-Swift.h"

@implementation ReceiptColumnPrice

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    if (forCSV) {
        return [receipt priceAsString];
    }
    return [receipt formattedPrice];
}

@end
