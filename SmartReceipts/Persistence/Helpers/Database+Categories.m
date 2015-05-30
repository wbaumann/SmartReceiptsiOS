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

@implementation Database (Categories)

- (NSArray *)listAllCategories {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:CategoriesTable.TABLE_NAME];
    [select orderBy:CategoriesTable.COLUMN_NAME ascending:YES];
    return [[self createAdapterUsingQuery:select forModel:[WBCategory class]] allObjects];
}

- (BOOL)saveCategory:(WBCategory *)category {
    return NO;
}

- (BOOL)updateCategory:(WBCategory *)category {
    return NO;
}

- (BOOL)deleteCategory:(WBCategory *)category {
    return NO;
}

@end
