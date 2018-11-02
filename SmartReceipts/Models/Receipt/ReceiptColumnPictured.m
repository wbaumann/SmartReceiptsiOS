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
#import "LocalizedString.h"

@implementation ReceiptColumnPictured

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    if ([receipt hasImage]) {
        return LocalizedString(@"yes", nil);
    } else if ([receipt hasPDF]) {
        return LocalizedString(@"yes_as_pdf", nil);
    } else {
        return LocalizedString(@"no", nil);
    }
}

@end
