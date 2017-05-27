//
//  ReceiptColumnBlank.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnBlank.h"
#import "WBReceipt.h"

@implementation ReceiptColumnBlank

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return @"";
}

- (NSString *)header {
    return @"";
}

@end
