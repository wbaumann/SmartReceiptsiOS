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

+(NSString*) TABLE_NAME;

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db;
- (BOOL)createTable;

-(NSArray*) selectAllInDatabase:(FMDatabase*) database;
-(NSArray*) selectAll;
-(WBTrip*) selectWithName:(NSString*) name;
-(WBTrip*) insertWithName:(NSString*) name from:(NSDate*) from to:(NSDate*) to;
-(WBTrip*) updateTrip:(WBTrip*) oldTrip dir:(NSString*) dir from:(NSDate*) from to:(NSDate*) to;
-(BOOL) updateTrip:(WBTrip*) trip miles:(double) total;
-(BOOL) deleteWithName:(NSString*) name;

-(NSString*) sumAndUpdatePriceForTrip:(WBTrip*) trip inDatabase:(FMDatabase*)db;

-(int) cachedCount;
    
+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB overwrite:(BOOL) overwrite;

-(NSString*) hintForString:(NSString*) str;

@end
