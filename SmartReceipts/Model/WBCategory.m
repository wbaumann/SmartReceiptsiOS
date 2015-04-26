//
//  WBCategory.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCategory.h"

static NSString * const TABLE_NAME = @"categories";
static NSString * const COLUMN_NAME = @"name";
static NSString * const COLUMN_CODE = @"code";
static NSString * const COLUMN_BREAKDOWN = @"breakdown";

@implementation WBCategory
{
    NSString *_name, *_code;
}

- (id)initWithName:(NSString*)name code:(NSString*) code
{
    self = [super init];
    if (self) {
        _name = name;
        _code = code;
    }
    return self;
}

-(NSString*)name{
    return _name;
}

-(NSString*)code{
    return _code;
}

+(NSString*) CATEGORY_NAME_BREAKFAST {
    return NSLocalizedString(@"Breakfast", nil);
}

+(NSString*) CATEGORY_NAME_LUNCH {
    return NSLocalizedString(@"Lunch", nil);
}

+(NSString*) CATEGORY_NAME_DINNER {
    return NSLocalizedString(@"Dinner", nil);
}

+(NSDictionary*) namesToCodeMapFromCategories:(NSArray*)categories {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (WBCategory* category in categories) {
        [dict setObject:[category code] forKey:[category name]];
    }
    return dict;
}

@end
