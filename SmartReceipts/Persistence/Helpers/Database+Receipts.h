//
//  Database+Receipts.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/objc.h>
#import "Database.h"

@class WBReceipt;
@class WBTrip;

@interface Database (Receipts)

- (BOOL)createReceiptsTable;
- (BOOL)saveReceipt:(WBReceipt *)receipt;
- (NSArray *)allReceiptsForTrip:(WBTrip *)trip descending:(BOOL)desc;

@end
