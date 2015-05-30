//
//  WBCategory.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <FMDB/FMResultSet.h>
#import "WBCategory.h"
#import "DatabaseTableNames.h"

static NSString *const TABLE_NAME = @"categories";
static NSString *const COLUMN_NAME = @"name";
static NSString *const COLUMN_CODE = @"code";
static NSString *const COLUMN_BREAKDOWN = @"breakdown";

@interface WBCategory ()

@property (nonatomic, copy) NSString *originalName;

@end

@implementation WBCategory

- (id)initWithName:(NSString *)name code:(NSString *)code {
    self = [super init];
    if (self) {
        _name = name;
        _originalName = name;
        _code = code;
    }
    return self;
}

+ (NSString *)CATEGORY_NAME_BREAKFAST {
    return NSLocalizedString(@"Breakfast", nil);
}

+ (NSString *)CATEGORY_NAME_LUNCH {
    return NSLocalizedString(@"Lunch", nil);
}

+ (NSString *)CATEGORY_NAME_DINNER {
    return NSLocalizedString(@"Dinner", nil);
}

+ (NSDictionary *)namesToCodeMapFromCategories:(NSArray *)categories {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (WBCategory *category in categories) {
        [dict setObject:[category code] forKey:[category name]];
    }
    return dict;
}

- (void)loadDataFromResultSet:(FMResultSet *)resultSet {
    self.code = [resultSet stringForColumn:CategoriesTable.COLUMN_CODE];
    self.name = [resultSet stringForColumn:CategoriesTable.COLUMN_NAME];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    WBCategory *category = other;

    return [self.name isEqualToString:category.name];
}

- (NSUInteger)hash {
    return self.name.hash;
}

- (void)setName:(NSString *)name {
    _name = [name mutableCopy];

    if (!self.originalName) {
        [self setOriginalName:name];
    }
}

@end
