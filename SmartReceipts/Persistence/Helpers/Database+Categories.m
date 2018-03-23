//
//  Database+Categories.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "Database+Categories.h"
#import "WBCategory.h"
#import "Database+Functions.h"
#import "FetchedModelAdapter.h"
#import "DatabaseQueryBuilder.h"
#import "DatabaseTableNames.h"
#import "Database+Notify.h"

@interface WBCategory (Expose)

@property (nonatomic, copy) NSString *originalName;

@end

@implementation Database (Categories)

- (BOOL)createCategoriesTable {
    NSArray *createCategoriesTable = @[
            @"CREATE TABLE ", CategoriesTable.TABLE_NAME, @" (",
            CategoriesTable.COLUMN_NAME, @" TEXT PRIMARY KEY, ",
            CategoriesTable.COLUMN_CODE, @" TEXT, ",
            CategoriesTable.COLUMN_BREAKDOWN, @" BOOLEAN DEFAULT 1, ",
            CategoriesTable.COLUMN_CUSTOM_ORDER_ID, @" INTEGER DEFAULT 0", @");"
    ];
    return [self executeUpdateWithStatementComponents:createCategoriesTable];
}

- (NSArray *)listAllCategories {
    return [[self fetchedAdapterForCategories] allObjects];
}

- (BOOL)saveCategory:(WBCategory *)category {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self saveCategory:category usingDatabase:db];
    }];
    return result;
}

- (BOOL)saveCategory:(WBCategory *)category usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:CategoriesTable.TABLE_NAME];
    [insert addParam:CategoriesTable.COLUMN_CODE value:category.code];
    [insert addParam:CategoriesTable.COLUMN_NAME value:category.name];
    BOOL result = [self executeQuery:insert usingDatabase:database];
    if (result) {
        [self notifyInsertOfModel:category];
    }
    return result;
}

- (BOOL)updateCategory:(WBCategory *)category {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:CategoriesTable.TABLE_NAME];
    [update addParam:CategoriesTable.COLUMN_CODE value:category.code];
    [update addParam:CategoriesTable.COLUMN_NAME value:category.name];
    [update where:CategoriesTable.COLUMN_NAME value:category.originalName];
    BOOL result = [self executeQuery:update];
    if (result) {
        [self notifyUpdateOfModel:category];
    }
    return result;
}

- (BOOL)deleteCategory:(WBCategory *)category {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:CategoriesTable.TABLE_NAME];
    [delete where:CategoriesTable.COLUMN_NAME value:category.name];
    BOOL result = [self executeQuery:delete];
    if (result) {
        [self notifyDeleteOfModel:category];
    }
    return result;
}

- (FetchedModelAdapter *)fetchedAdapterForCategories {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:CategoriesTable.TABLE_NAME];
    [select caseInsensitiveOrderBy:CategoriesTable.COLUMN_NAME ascending:YES];
    return [self createAdapterUsingQuery:select forModel:[WBCategory class]];
}

@end
