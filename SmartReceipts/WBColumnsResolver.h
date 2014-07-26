//
//  WBColumnsResolver.h
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBCategory.h"
#import "WBColumn.h"
#import "WBTrip.h"
#import "WBReceipt.h"

@interface WBColumnsResolver : NSObject

- (id)initWithCategories:(NSArray*) categories;

- (NSString*)resolveToString:(WBColumn*) column forTrip:(WBTrip*) trip forReceipt:(WBReceipt*) receipt withReceiptIndex:(int) idxReceipt isCsv:(BOOL) isCsv;

@end
