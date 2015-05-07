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

@interface Database (Receipts)

- (BOOL)createReceiptsTable;

@end
