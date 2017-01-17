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
    BOOL result = [self createColumnsTableWithName:PDFTable.TABLE_NAME];
    LOGGER_DEBUG(@"createPDFColumnsTable: %@, success=%d", PDFTable.TABLE_NAME, result);
    return result;
}

- (NSArray *)allPDFColumns {
    NSArray *result = [self fetchAllColumnsFromTable:PDFTable.TABLE_NAME];
    LOGGER_DEBUG(@"allPDFColumns: %@", result.description);
    return result;
}

- (BOOL)replaceAllPDFColumnsWith:(NSArray *)columns {
    BOOL result = [self replaceAllColumnsInTable:PDFTable.TABLE_NAME columns:columns];
    LOGGER_DEBUG(@"replaceAllPDFColumnsWith: %@, success=%d", columns.description, result);
    return result;
}

@end
