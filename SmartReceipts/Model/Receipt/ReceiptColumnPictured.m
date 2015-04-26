//
//  ReceiptColumnPictured.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnPictured.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnPictured

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    if ([receipt hasImageForTrip:receipt.trip]) {
        return NSLocalizedString(@"Yes", nil);
    } else if ([receipt hasPDFForTrip:receipt.trip]) {
        return NSLocalizedString(@"Yes - As PDF", nil);
    } else {
        return NSLocalizedString(@"No", nil);
    }
}

@end
