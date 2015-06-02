//
//  Database+Columns.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMResultSet.h>
#import "Database+Columns.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "ReceiptColumn.h"
#import "FMDatabase.h"
#import "DatabaseQueryBuilder.h"

@implementation Database (Columns)

- (BOOL)createColumnsTableWithName:(NSString *)tableName {
    NSArray *createTable = @[
            @"CREATE TABLE ", tableName, @" (",
            CSVTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ",
            CSVTable.COLUMN_TYPE, @" TEXT", @");"
    ];
    return [self executeUpdateWithStatementComponents:createTable];
}

- (NSArray *)fetchAllColumnsFromTable:(NSString *)tableName {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];

    NSMutableArray *loaded = [[NSMutableArray alloc] init];

    [self.databaseQueue inDatabase:^(FMDatabase* database){
        FMResultSet* resultSet = [database executeQuery:query];

        while ([resultSet next]) {
            ReceiptColumn *col = [ReceiptColumn columnWithIndex:[resultSet intForColumn:CSVTable.COLUMN_ID] name:[resultSet stringForColumn:CSVTable.COLUMN_TYPE]];
            [loaded addObject:col];
        }

    }];

    return [NSArray arrayWithArray:loaded];
}

- (BOOL)replaceAllColumnsInTable:(NSString *)tableName columns:(NSArray *)columns {
    __block BOOL result;
    [self.databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        result = [database executeUpdate:query];
        if (!result) {
            *rollback = YES;
            return;
        }

        for (Column *col in columns) {
            if (![self insertWithColumnName:[col name] intoTable:tableName usingDatabase:database]) {
                *rollback = YES;
                return;
            }
        }

        result = YES;
    }];
    return result;
}

- (BOOL)insertWithColumnName:(NSString *)columnName intoTable:(NSString *)tableName usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:tableName];
    [insert addParam:CSVTable.COLUMN_TYPE value:columnName];
    return [self executeQuery:insert usingDatabase:database];
}

@end
