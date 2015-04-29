//
//  ReceiptColumnReceiptIndex.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnReceiptIndex.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnReceiptIndex

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [NSString stringWithFormat:@"%ld", receipt.reportIndex];
}

@end
