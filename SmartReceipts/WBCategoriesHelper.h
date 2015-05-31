//
//  WBCategory+WBDB.h
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCategory.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface WBCategoriesHelper : NSObject

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db;

// select or get from cache if there was no insert/update/delete since last successful select
-(NSArray*) selectAll;

+(BOOL) insertWithName:(NSString*) name code:(NSString*) code intoQueue:(FMDatabaseQueue *)queue;

-(NSArray*) categoriesNames;

@end
