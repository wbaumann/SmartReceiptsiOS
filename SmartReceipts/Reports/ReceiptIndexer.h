//
//  ReceiptIndexer.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBReceipt;

@interface ReceiptIndexer : NSObject

+ (NSArray *)indexReceipts:(NSArray *)receipts filteredWith:(BOOL (^)(WBReceipt *))filter;

@end
