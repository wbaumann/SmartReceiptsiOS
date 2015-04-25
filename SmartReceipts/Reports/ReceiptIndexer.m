//
//  ReceiptIndexer.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptIndexer.h"
#import "WBReceipt.h"

@implementation ReceiptIndexer

+ (NSArray *)indexReceipts:(NSArray *)receipts filteredWith:(BOOL (^)(WBReceipt *))filter {
    NSMutableArray *filteredAndIndexed = [NSMutableArray array];
    int i = 0;
    for (WBReceipt *rec in receipts) {
        if (filter(rec)) {
            continue;
        }
        ++i;
        [rec setReportIndex:i];
        [filteredAndIndexed addObject:rec];
    }
    return filteredAndIndexed.copy;
}

@end
