//
//  DatabaseCategoriesTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "DatabaseTestsHelper.h"
#import "Database+Categories.h"
#import "Database+Functions.h"
#import "DatabaseTableNames.h"
#import "WBCategory.h"

@interface DatabaseCategoriesTest : SmartReceiptsTestsBase

@end

@implementation DatabaseCategoriesTest

- (void)testCategorySave {
    NSUInteger before = [self.db countRowsInTable:CategoriesTable.TABLE_NAME];

    WBCategory *category = [[WBCategory alloc] initWithName:@"TestCategory" code:@"TCRY"];
    [self.db saveCategory:category];

    NSUInteger after = [self.db countRowsInTable:CategoriesTable.TABLE_NAME];
    XCTAssertEqual(before + 1, after);
}

- (void)testCategoryUpdate {
    WBCategory *category = [[WBCategory alloc] initWithName:@"TestCategory" code:@"TCRY"];
    [self.db saveCategory:category];

    NSUInteger before = [self.db countRowsInTable:CategoriesTable.TABLE_NAME];

    [category setName:@"AlteredName"];
    [self.db updateCategory:category];

    NSUInteger after = [self.db countRowsInTable:CategoriesTable.TABLE_NAME];
    XCTAssertEqual(before, after);

    NSArray *all = [self.db listAllCategories];
    XCTAssertTrue([all containsObject:category]);
}

- (void)testCategoryDelete {
    WBCategory *category = [[WBCategory alloc] initWithName:@"TestCategory" code:@"TCRY"];
    [self.db saveCategory:category];

    NSUInteger before = [self.db countRowsInTable:CategoriesTable.TABLE_NAME];

    [self.db deleteCategory:category];

    NSUInteger after = [self.db countRowsInTable:CategoriesTable.TABLE_NAME];
    XCTAssertEqual(before - 1, after);
}

- (void)testListAll {
    NSArray *categories = [self.db listAllCategories];
    XCTAssertEqual(25, categories.count);
}

@end
