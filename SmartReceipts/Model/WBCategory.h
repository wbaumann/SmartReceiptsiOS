//
//  WBCategory.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"

@interface WBCategory : NSObject <FetchedModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

- (id)initWithName:(NSString*)name code:(NSString*) code;

+(NSString*) CATEGORY_NAME_BREAKFAST;
+(NSString*) CATEGORY_NAME_LUNCH;
+(NSString*) CATEGORY_NAME_DINNER;

+(NSDictionary*) namesToCodeMapFromCategories:(NSArray*)categories;

@end
