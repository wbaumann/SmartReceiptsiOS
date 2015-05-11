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
- (WBTrip *)insertWithName:(NSString *)name from:(NSDate *)from to:(NSDate *)to;
- (WBTrip *)updateTrip:(WBTrip *)oldTrip dir:(NSString *)dir from:(NSDate *)from to:(NSDate *)to;
- (BOOL)deleteWithName:(NSString *)name;

- (NSDecimalNumber *)sumAndUpdatePriceForTrip:(WBTrip *)trip inDatabase:(FMDatabase *)db;

- (int)cachedCount;

+ (BOOL)mergeDatabase:(FMDatabase *)currDB withDatabase:(FMDatabase *)importDB overwrite:(BOOL)overwrite;

@end
