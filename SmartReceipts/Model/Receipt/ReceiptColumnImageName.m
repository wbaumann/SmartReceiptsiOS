//
//  ReceiptColumnImageName.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnImageName.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnImageName

- (NSString *)valueFromReceipt:(WBReceipt *)receipt receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
#warning FIXME: on Android (receipt.hasFile()) ? "" : receipt.getFileName() looks like bug
    return [receipt hasFileForTrip:receipt.trip] ? [receipt imageFileName] : @"";
}

@end
