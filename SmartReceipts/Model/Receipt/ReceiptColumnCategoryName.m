//
//  ReceiptColumnCategoryName.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnCategoryName.h"
#import "WBReceipt.h"

@implementation ReceiptColumnCategoryName

- (NSString *)valueFromReceipt:(WBReceipt *)receipt inTrip:(WBTrip *)trip receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [receipt category];
}

@end
