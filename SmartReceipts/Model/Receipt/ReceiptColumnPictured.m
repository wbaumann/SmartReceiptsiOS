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

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip forCSV:(BOOL)forCSV {
    if ([receipt hasImageForTrip:trip]) {
        return NSLocalizedString(@"Yes", nil);
    } else if ([receipt hasPDFForTrip:trip]) {
        return NSLocalizedString(@"Yes - As PDF", nil);
    } else {
        return NSLocalizedString(@"No", nil);
    }
}

@end
