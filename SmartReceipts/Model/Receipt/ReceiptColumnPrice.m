//
//  ReceiptColumnPrice.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnPrice.h"
#import "WBReceipt.h"

@implementation ReceiptColumnPrice

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    //TODO jaanus: price has if(forCSV) and tax does not?
    if (forCSV) {
        return [receipt priceAsString];
    }
    return [receipt priceWithCurrencyFormatted];
}

@end
