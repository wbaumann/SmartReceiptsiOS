//
//  Database+CSVColumns.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class Column;

@interface Database (CSVColumns)

- (BOOL)createCSVColumnsTable;
- (NSArray *)allCSVColumns;
- (BOOL)replaceAllCSVColumnsWith:(NSArray *)columns;
- (BOOL)reorderCSVColumn:(Column *)columnOne withCSVColumn:(Column *)columnTwo;
- (NSInteger)nextCustomOrderIdForCSVColumn;
- (BOOL)addCSVColumn:(Column *)column;
- (BOOL)removeCSVColumn:(Column *)column;
- (NSInteger)nextCSVColumnObjectID;

@end
