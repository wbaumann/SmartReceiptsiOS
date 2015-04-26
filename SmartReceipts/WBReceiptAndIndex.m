//
//  WBReceiptAndIndex.m
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceiptAndIndex.h"

@implementation WBReceiptAndIndex
{
    WBReceipt* _receipt;
    int _index;
}

- (id) initWithReceipt:(WBReceipt*)receipt andIndex:(int)index
{
    self = [super init];
    if (self) {
        _receipt = receipt;
        _index = index;
    }
    return self;
}

- (WBReceipt*) receipt {
    return _receipt;
}

- (int) index {
    return _index;
}

+ (NSArray *)receiptsAndIndicesFromReceipts:(NSArray *)receipts filteredWith:(BOOL (^)(WBReceipt *))filter {
    NSMutableArray *arr = [NSMutableArray new];
    int i = 0;
    for (WBReceipt *rec in receipts) {
        if (filter(rec)) {
            continue;
        }
        ++i;
        [rec setReportIndex:i];
        [arr addObject:[[WBReceiptAndIndex alloc] initWithReceipt:rec andIndex:i]];
    }
    return arr.copy;
}

@end
