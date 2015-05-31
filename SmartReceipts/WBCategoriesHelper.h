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
-(NSArray*) selectAll;
-(NSArray*) categoriesNames;

@end
