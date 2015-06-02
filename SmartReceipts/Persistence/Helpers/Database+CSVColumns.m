//
//  Database+CSVColumns.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+CSVColumns.h"
#import "Database+Columns.h"
#import "DatabaseTableNames.h"

@interface Database (ColumnsExpose)

- (BOOL)createColumnsTableWithName:(NSString *)tableName;
- (NSArray *)fetchAllColumnsFromTable:(NSString *)tableName;
- (BOOL)replaceAllColumnsInTable:(NSString *)tableName columns:(NSArray *)columns;

@end

@implementation Database (CSVColumns)

- (BOOL)createCSVColumnsTable {
    return [self createColumnsTableWithName:CSVTable.TABLE_NAME];
}

- (NSArray *)allCSVColumns {
    return [self fetchAllColumnsFromTable:CSVTable.TABLE_NAME];
}

- (BOOL)replaceAllCSVColumnsWith:(NSArray *)columns {
    return [self replaceAllColumnsInTable:CSVTable.TABLE_NAME columns:columns];
}

@end
