//
//  WBCategory.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchedModel.h"
#import "Pickable.h"

@interface WBCategory : NSObject <FetchedModel, Pickable>

@property (nonatomic) NSInteger objectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic) NSInteger customOrderId;
@property (nonatomic, readonly) NSString *uuid;

- (id)initWithName:(NSString*)name code:(NSString*)code;
- (id)initWithName:(NSString*)name code:(NSString*)code uuid:(NSString *)uuid;
- (id)initWithName:(NSString *)name code:(NSString *)code customOrderId:(NSInteger)customOrderId;
- (id)initWithName:(NSString *)name code:(NSString *)code customOrderId:(NSInteger)customOrderId objectId:(NSInteger)objectId;
- (id)initWithName:(NSString *)name code:(NSString *)code customOrderId:(NSInteger)customOrderId objectId:(NSInteger)objectId uuid:(NSString *)uuid;

+(NSString*) CATEGORY_NAME_BREAKFAST;
+(NSString*) CATEGORY_NAME_LUNCH;
+(NSString*) CATEGORY_NAME_DINNER;

+(NSDictionary*) namesToCodeMapFromCategories:(NSArray*)categories;

@end
