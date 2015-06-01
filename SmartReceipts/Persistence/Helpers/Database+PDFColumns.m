//
//  Database+PDFColumns.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+PDFColumns.h"
#import "DatabaseTableNames.h"
#import "Database+Columns.h"

@interface Database (ColumnsExpose)

- (BOOL)createColumnsTableWithName:(NSString *)tableName;
- (NSArray *)fetchAllColumnsFromTable:(NSString *)tableName;
- (BOOL)replaceAllColumnsInTable:(NSString *)tableName columns:(NSArray *)columns;

@end

@implementation Database (PDFColumns)

- (BOOL)createPDFColumnsTable {
    return [self createColumnsTableWithName:PDFTable.TABLE_NAME];
}

- (NSArray *)allPDFColumns {
    return [self fetchAllColumnsFromTable:PDFTable.TABLE_NAME];
}

- (BOOL)replaceAllPDFColumnsWith:(NSArray *)columns {
    return [self replaceAllColumnsInTable:PDFTable.TABLE_NAME columns:columns];
}

@end
