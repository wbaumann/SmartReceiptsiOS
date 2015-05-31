//
//  WBCategory+WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCategoriesHelper.h"
#import "DatabaseTableNames.h"

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

#pragma mark - commons

-(NSArray*) categoriesNames {
    NSArray *categories = [self selectAll];
    NSMutableArray *names = @[].mutableCopy;
    for (WBCategory* cat in categories) {
        [names addObject:[cat name]];
    }
    return [names copy];
}

@end
