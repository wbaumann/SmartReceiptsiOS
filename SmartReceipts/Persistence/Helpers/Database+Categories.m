//
//  Database+Categories.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <sys/select.h>
#import "Database+Categories.h"
#import "WBCategory.h"
#import "Database+Functions.h"
#import "FetchedModelAdapter.h"
#import "DatabaseQueryBuilder.h"
#import "DatabaseTableNames.h"

@interface WBCategory (Expose)

@property (nonatomic, copy) NSString *originalName;

@end

@implementation Database (Categories)

- (NSArray *)listAllCategories {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:CategoriesTable.TABLE_NAME];
    [select orderBy:CategoriesTable.COLUMN_NAME ascending:YES];
    return [[self createAdapterUsingQuery:select forModel:[WBCategory class]] allObjects];
}

- (BOOL)saveCategory:(WBCategory *)category {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:CategoriesTable.TABLE_NAME];
    [insert addParam:CategoriesTable.COLUMN_CODE value:category.code];
    [insert addParam:CategoriesTable.COLUMN_NAME value:category.name];
    return [self executeQuery:insert];
}

- (BOOL)updateCategory:(WBCategory *)category {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:CategoriesTable.TABLE_NAME];
    [update addParam:CategoriesTable.COLUMN_CODE value:category.code];
    [update addParam:CategoriesTable.COLUMN_NAME value:category.name];
    [update where:CategoriesTable.COLUMN_NAME value:category.originalName];
    return [self executeQuery:update];
}

- (BOOL)deleteCategory:(WBCategory *)category {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:CategoriesTable.TABLE_NAME];
    [delete where:CategoriesTable.COLUMN_NAME value:category.name];
    return [self executeQuery:delete];
}

@end
