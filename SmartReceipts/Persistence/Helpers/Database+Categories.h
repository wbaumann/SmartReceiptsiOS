//
//  Database+Categories.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class WBCategory;

@interface Database (Categories)

- (NSArray *)listAllCategories;
- (BOOL)saveCategory:(WBCategory *)category;
- (BOOL)updateCategory:(WBCategory *)category;
- (BOOL)deleteCategory:(WBCategory *)category;

@end
