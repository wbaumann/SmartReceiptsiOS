//
//  WBReceiptAndIndex.h
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBReceipt.h"

@interface WBReceiptAndIndex : NSObject

- (id) initWithReceipt:(WBReceipt*)receipt andIndex:(int)index;

- (WBReceipt*) receipt;

- (int) index;

+ (NSArray*) receiptsAndIndicesFromReceipts:(NSArray*) receipts filteredWith:(BOOL (^)(WBReceipt*)) filter;

@end
