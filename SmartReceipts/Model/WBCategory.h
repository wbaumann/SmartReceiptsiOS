//
//  WBCategory.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBCategory : NSObject

- (id)initWithName:(NSString*)name code:(NSString*) code;

-(NSString*)name;
-(NSString*)code;

+(NSString*) CATEGORY_NAME_BREAKFAST;
+(NSString*) CATEGORY_NAME_LUNCH;
+(NSString*) CATEGORY_NAME_DINNER;

+(NSDictionary*) namesToCodeMapFromCategories:(NSArray*)categories;

@end
