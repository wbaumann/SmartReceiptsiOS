//
//  WBColumn+WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBColumnsHelper.h"
#import "ReceiptColumn.h"

static NSString * const TABLE_NAME_PDF = @"pdfcolumns";
static NSString * const TABLE_NAME_CSV = @"csvcolumns";
static NSString * const COLUMN_ID = @"id";
static NSString * const COLUMN_TYPE = @"type";

@implementation WBColumnsHelper
{
    FMDatabaseQueue* _databaseQueue;
    NSString* _tableName;
}

+ (NSString*) TABLE_NAME_CSV {
    return TABLE_NAME_CSV;
}

+ (NSString*) TABLE_NAME_PDF {
    return TABLE_NAME_PDF;
}

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db tableName:(NSString*) tabName
{
    self = [super init];
    if (self) {
        self->_databaseQueue = db;
        self->_tableName = tabName;
    }
    return self;
}

- (BOOL) createTable {
    NSString* query = [@[
                         @"CREATE TABLE " , _tableName , @" ("
                         , COLUMN_ID , @" INTEGER PRIMARY KEY AUTOINCREMENT, "
                         , COLUMN_TYPE , @" TEXT"
                         , @");"
                         ] componentsJoinedByString:@""];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        result = [database executeUpdate:query];
    }];
    return result;
}

#pragma mark - CRUD

-(NSArray*) selectAll {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", _tableName];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [_databaseQueue inDatabase:^(FMDatabase* database){
        FMResultSet* resultSet = [database executeQuery:query];
        
        const int idIndex = [resultSet columnIndexForName:COLUMN_ID];
        const int typeIndex = [resultSet columnIndexForName:COLUMN_TYPE];
        
        while ([resultSet next]) {
            ReceiptColumn *col = [ReceiptColumn columnWithIndex:[resultSet intForColumnIndex:idIndex] name:[resultSet stringForColumnIndex:typeIndex]];
            [array addObject:col];
        }
        
    }];
    
    return [array copy];
}

- (BOOL) insertWithColumnName:(NSString*) columnName inDatabase:(FMDatabase*) database {
    NSString *q = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)", _tableName, COLUMN_TYPE];
    return [database executeUpdate:q, columnName];
}

- (BOOL) insertWithColumnName:(NSString*) columnName {
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        result = [self insertWithColumnName:columnName inDatabase:database];
    }];
    return result;
}

-(BOOL) updateWithIndex:(int) index name:(NSString*) name {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", _tableName, COLUMN_TYPE, COLUMN_ID];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:query, name, [NSNumber numberWithInt:index]];
    }];
    return result;
}

-(BOOL) deleteWithIndex:(int) index {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", _tableName, COLUMN_ID];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        result = [database executeUpdate:query, [NSNumber numberWithInt:index]];
    }];
    return result;
}

-(BOOL) deleteAllAndInsertColumns:(NSArray*) columns {
    __block BOOL result;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", _tableName];
        result = [database executeUpdate:query];
        if (!result) {
            *rollback = YES;
            return;
        }
        
        for (WBColumn *col in columns) {
            if (![self insertWithColumnName:[col name] inDatabase:database]) {
                *rollback = YES;
                return;
            }
        }
        
        result = YES;
    }];
    return result;
}

#pragma mark - merge

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB forTable:(NSString*) tableName {
    NSLog(@"Merging columns for %@", tableName);
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    FMResultSet* resultSet = [importDB executeQuery:selectQuery];
    
    if (![resultSet next]) {
        return false;
    }
    
    const int idIndex = [resultSet columnIndexForName:COLUMN_ID];
    const int typeIndex = [resultSet columnIndexForName:COLUMN_TYPE];
    
    NSString * insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@) VALUES (?,?)",
                              tableName,
                              COLUMN_ID, COLUMN_TYPE];
    
    //No clean way to merge (since auto-increment is not guaranteed to have any order and there isn't enough outlying data) => Always overwirte
    [currDB executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", tableName]];
    
    do {
        
        NSNumber *index = [NSNumber numberWithInt:[resultSet intForColumnIndex:idIndex]];
        NSString *type = [resultSet stringForColumnIndex:typeIndex];
        
#warning REVIEW: as on Android we ignore insert success, but should it be like this?
        [currDB executeUpdate:insertQuery,index,type];
        
    } while ([resultSet next]);
    
    return true;
}

@end
