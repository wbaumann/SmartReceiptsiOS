//
//  WBTrip+WBDB.h
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTrip.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface WBTripsHelper : NSObject

+ (NSString *)TABLE_NAME;

- (id)initWithDatabaseQueue:(FMDatabaseQueue *)db;

- (NSArray *)selectAllInDatabase:(FMDatabase *)database;
- (NSArray *)selectAll;
- (BOOL)deleteWithName:(NSString *)name;

+ (BOOL)mergeDatabase:(FMDatabase *)currDB withDatabase:(FMDatabase *)importDB overwrite:(BOOL)overwrite;

@end
