//
//  ReceiptColumnImagePath.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnImagePath.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnImagePath

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip forCSV:(BOOL)forCSV {
    return [receipt hasFileForTrip:trip] ? [receipt imageFilePathForTrip:trip] : @"";
}

@end
