//
//  WBCategory+WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCategoriesHelper.h"
#import "Database.h"

static NSString * const TABLE_NAME = @"categories";
static NSString * const COLUMN_NAME = @"name";
static NSString * const COLUMN_CODE = @"code";
static NSString * const COLUMN_BREAKDOWN = @"breakdown";

@implementation WBCategoriesHelper
{
    FMDatabaseQueue* _databaseQueue;
    
    // simple cache to not repeat 'select' when reading only
    NSArray* _cachedCategories;
}

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db
{
    self = [super init];
    if (self) {
        self->_databaseQueue = db;
        self->_cachedCategories = nil;
    }
    return self;
}

- (BOOL) createTable {
    return [WBCategoriesHelper createTableInQueue:_databaseQueue];
}

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue {
    NSString* query = [@[
                         @"CREATE TABLE " , TABLE_NAME , @" ("
                         , COLUMN_NAME , @" TEXT PRIMARY KEY, "
                         , COLUMN_CODE , @" TEXT, "
                         , COLUMN_BREAKDOWN , @" BOOLEAN DEFAULT 1"
                         , @");"
                         ] componentsJoinedByString:@""];

    __block BOOL result;
    [queue inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:query];
    }];
    return result;
}

#pragma mark - CRUD

-(NSArray*) selectAll {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_NAME];
    
    __block NSArray *categories = nil;
    
    [_databaseQueue inDatabase:^(FMDatabase* database){
        if (_cachedCategories) {
            categories = _cachedCategories;
            return;
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        FMResultSet* resultSet = [database executeQuery:query];
        
        const int nameIndex = [resultSet columnIndexForName:COLUMN_NAME];
        const int codeIndex = [resultSet columnIndexForName:COLUMN_CODE];
        
        while ([resultSet next]) {
            WBCategory *category = [[WBCategory alloc] initWithName:[resultSet stringForColumnIndex:nameIndex] code:[resultSet stringForColumnIndex:codeIndex]];
            
            [array addObject:category];
        }
        
        // we sort it here to keep lock for _cachedCategories
        categories = [array sortedArrayUsingComparator:^NSComparisonResult(WBCategory* a, WBCategory* b) {
            return [[a name] caseInsensitiveCompare:[b name]];
        }];
        
        _cachedCategories = categories;
        
    }];
    
    return categories;
}

- (BOOL)insertWithName:(NSString *)name code:(NSString *)code {
    _cachedCategories = nil;
    return [WBCategoriesHelper insertWithName:name code:code intoQueue:_databaseQueue];
}

+ (BOOL)insertWithName:(NSString *)name code:(NSString *)code intoQueue:(FMDatabaseQueue *)queue {
    NSString *q = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@) VALUES (?,?)", CategoriesTable.TABLE_NAME, CategoriesTable.COLUMN_NAME, CategoriesTable.COLUMN_CODE];

    __block BOOL result;
    [queue inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:q, name, code];
    }];

    return result;
}

-(BOOL) updateWithName:(NSString*) oldName toName:(NSString*) newName code:(NSString*) code {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? , %@ = ? WHERE %@ = ?", TABLE_NAME, COLUMN_NAME, COLUMN_CODE, COLUMN_NAME];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        _cachedCategories = nil;
        result = [db executeUpdate:query, newName, code, oldName];
    }];
    return result;
}

-(BOOL) deleteWithName:(NSString*) name {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_NAME];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        _cachedCategories = nil;
        result = [database executeUpdate:query, name];
    }];
    return result;
}

#pragma mark - commons

-(NSArray*) categoriesNames {
    NSArray *categories = [self selectAll];
    NSMutableArray *names = @[].mutableCopy;
    for (WBCategory* cat in categories) {
        [names addObject:[cat name]];
    }
    return [names copy];
}

-(void) clearCache {
    _cachedCategories = nil;
}

#pragma mark - merge

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB {
    NSLog(@"Merging categories");
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_NAME];
    
    FMResultSet* resultSet = [importDB executeQuery:selectQuery];
    
    if (![resultSet next]) {
        return false;
    }
    
    const int nameIndex = [resultSet columnIndexForName:COLUMN_NAME];
    const int codeIndex = [resultSet columnIndexForName:COLUMN_CODE];
    
    NSString * insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@) VALUES (?,?)",
                              TABLE_NAME,
                              COLUMN_NAME, COLUMN_CODE];
    
    //No clean way to merge (since auto-increment is not guaranteed to have any order and there isn't enough outlying data) => Always overwirte
    [currDB executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", TABLE_NAME]];
    
    do {
        
        NSString *name = [resultSet stringForColumnIndex:nameIndex];
        NSString *code = [resultSet stringForColumnIndex:codeIndex];
        
        [currDB executeUpdate:insertQuery,name,code];
        
    } while ([resultSet next]);
    
    return true;
}

@end
