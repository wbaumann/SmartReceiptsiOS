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

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
#warning FIXME: on Android (receipt.hasFile()) ? "" : receipt.getFileName() looks like bug
    return [receipt hasFileForTrip:trip] ? [receipt imageFileName] : @"";
}

@end
