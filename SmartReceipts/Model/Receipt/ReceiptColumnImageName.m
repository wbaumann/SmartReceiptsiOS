//
//  ReceiptColumnImageName.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnImageName.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnImageName

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [receipt hasFileForTrip:receipt.trip] ? [receipt imageFileName] : @"";
}

@end
