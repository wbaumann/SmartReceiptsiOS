//
//  ReceiptColumn.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Column.h"

@class WBReceipt;
@class WBTrip;

@interface ReceiptColumn : Column
+ (ReceiptColumn *)columnWithIndex:(NSInteger)index name:(NSString *)columnName;
+ (ReceiptColumn *)columnName:(NSString *)columnName;
+ (NSArray *)availableColumnsNames;
- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV;

@end
