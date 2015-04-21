//
//  WBTrip+WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTripsHelper.h"

#import "WBDB.h"

#import "WBPreferences.h"

static NSString * const TABLE_NAME = @"trips";
static NSString * const COLUMN_NAME = @"name";
static NSString * const COLUMN_FROM = @"from_date";
static NSString * const COLUMN_TO = @"to_date";
static NSString * const COLUMN_FROM_TIMEZONE = @"from_timezone";
static NSString * const COLUMN_TO_TIMEZONE = @"to_timezone";
static NSString * const COLUMN_PRICE = @"price";
static NSString * const COLUMN_MILEAGE = @"miles_new";
static NSString * const COLUMN_COMMENT = @"trips_comment";
static NSString * const COLUMN_DEFAULT_CURRENCY = @"trips_default_currency";

static NSString * const NO_DATA = @"null";

@implementation WBTripsHelper
{
    FMDatabaseQueue* _databaseQueue;
    
    // we don't need to create cache for whole table, we use only count for few things, rest of data is anyway managed by single collection (+ sqlite has cache to lower IO operations number)
    // caches at all are common source of bugs, to be good we should make them transparent (with keeping current api), but I don't want unnecessary complexity in project
    int _cachedCount;
}

+(NSString*) TABLE_NAME {
    return TABLE_NAME;
}

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db
{
    self = [super init];
    if (self) {
        self->_databaseQueue = db;
    }
    return self;
}

-(BOOL) createTable {
    
    NSString* query = [@[
                         @"CREATE TABLE ", TABLE_NAME, @" (",
                         COLUMN_NAME , @" TEXT PRIMARY KEY, ",
                         COLUMN_FROM , @" DATE, ",
                         COLUMN_TO , @" DATE, ",
                         COLUMN_FROM_TIMEZONE , @" TEXT, ",
                         COLUMN_TO_TIMEZONE , @" TEXT, ",
                         COLUMN_PRICE , @" DECIMAL(10, 2) DEFAULT 0.00, ",
                         COLUMN_MILEAGE , @" DECIMAL(10, 2) DEFAULT 0.00, ",
                         COLUMN_COMMENT , @" TEXT, ",
                         COLUMN_DEFAULT_CURRENCY , @" TEXT",
                         @");"
                         ] componentsJoinedByString:@""];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        result = [database executeUpdate:query];
    }];
    
    _cachedCount = -1;
    
    return result;
}

#pragma mark - CRUD

-(NSArray*) selectAllInDatabase:(FMDatabase*) database {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", TABLE_NAME, COLUMN_TO];
    
    NSMutableArray *allTrips = [[NSMutableArray alloc] init];
    
    FMResultSet* resultSet = [database executeQuery:query];
    
    const int nameIndex = [resultSet columnIndexForName:COLUMN_NAME];
    const int fromIndex = [resultSet columnIndexForName:COLUMN_FROM];
    const int toIndex = [resultSet columnIndexForName:COLUMN_TO];
    const int fromTimeZoneIndex = [resultSet columnIndexForName:COLUMN_FROM_TIMEZONE];
    const int toTimeZoneIndex = [resultSet columnIndexForName:COLUMN_TO_TIMEZONE];
    const int priceIndex = [resultSet columnIndexForName:COLUMN_PRICE];
    const int milesIndex = [resultSet columnIndexForName:COLUMN_MILEAGE];
    
    while ([resultSet next]) {
        NSString* name = [resultSet stringForColumnIndex:nameIndex];
        NSString* curr = [[WBDB receipts] selectCurrencyForReceiptsWithParent:name inDatabase:database];
        if (!curr) {
            curr = [WBTrip MULTI_CURRENCY];
        }
        
        WBTrip *trip = [[WBTrip alloc] initWithName:name
                                              price:[NSDecimalNumber decimalNumberWithString:[resultSet stringForColumnIndex:priceIndex]]
                                        startDateMs:[resultSet longLongIntForColumnIndex:fromIndex]
                                          endDateMs:[resultSet longLongIntForColumnIndex:toIndex]
                                  startTimeZoneName:[resultSet stringForColumnIndex:fromTimeZoneIndex]
                                    endTimeZoneName:[resultSet stringForColumnIndex:toTimeZoneIndex]
                                       currencyCode:curr
                                              miles:[resultSet doubleForColumnIndex:milesIndex]];
        
        [allTrips addObject:trip];
    }
    
    _cachedCount = (int)[allTrips count];
    
    // copy to make immutable
    return [allTrips copy];
}

-(NSArray*) selectAll {
    __block NSArray *array = nil;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        array = [self selectAllInDatabase:database];
    }];
    return array;
}

-(WBTrip*) selectWithName:(NSString*) name {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_NAME];
    
    __block WBTrip *trip = nil;
    
    [_databaseQueue inDatabase:^(FMDatabase* database){
        FMResultSet* resultSet = [database executeQuery:query];
        
        if ([resultSet next]) {
            NSString* name = [resultSet stringForColumn:COLUMN_NAME];
            NSString* curr = [[WBDB receipts] selectCurrencyForReceiptsWithParent:name inDatabase:database];
            if (!curr) {
                curr = [WBTrip MULTI_CURRENCY];
            }
            
            trip = [[WBTrip alloc] initWithName:name
                                          price:[NSDecimalNumber decimalNumberWithString:[resultSet stringForColumn:COLUMN_PRICE]]
                                    startDateMs:[resultSet longLongIntForColumn:COLUMN_FROM]
                                      endDateMs:[resultSet longLongIntForColumn:COLUMN_TO]
                              startTimeZoneName:[resultSet stringForColumn:COLUMN_FROM_TIMEZONE]
                                endTimeZoneName:[resultSet stringForColumn:COLUMN_TO_TIMEZONE]
                                   currencyCode:curr
                                          miles:[resultSet doubleForColumn:COLUMN_MILEAGE]];
        }
        
    }];
    
    return trip;
}

-(WBTrip*) insertWithName:(NSString*) name from:(NSDate*) from to:(NSDate*) to {
    NSString *q = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?)", TABLE_NAME, COLUMN_NAME, COLUMN_FROM, COLUMN_TO, COLUMN_FROM_TIMEZONE, COLUMN_TO_TIMEZONE, COLUMN_DEFAULT_CURRENCY];
    
    name = [name lastPathComponent]; // for removing slashes
    
    NSNumber* llFrom = [NSNumber numberWithLongLong:(long long)([from timeIntervalSince1970] * 1000.0)];
    NSNumber* llTo = [NSNumber numberWithLongLong:(long long)([to timeIntervalSince1970] * 1000.0)];
    
    NSString* localTimeZoneName = [[NSTimeZone localTimeZone] name];
    NSString* defaultCurr = [WBPreferences defaultCurrency];
    
    __block WBTrip* trip = nil;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        if(![database executeUpdate:q, name, llFrom, llTo, localTimeZoneName, localTimeZoneName, defaultCurr]) {
            return;
        }
        
        trip = [[WBTrip alloc] initWithName:name startDate:from endDate:to currencyCode:[WBPreferences defaultCurrency]];
        
        if (_cachedCount != -1) {
            ++_cachedCount;
        }
        
    }];
    return trip;
}

-(WBTrip*) updateTrip:(WBTrip*) oldTrip dir:(NSString*) dir from:(NSDate*) from to:(NSDate*) to {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? , %@ = ? , %@ = ? ", TABLE_NAME, COLUMN_NAME, COLUMN_FROM, COLUMN_TO];
    
    dir = [dir lastPathComponent];
    
    NSNumber* llFrom = [NSNumber numberWithLongLong:(long long)([from timeIntervalSince1970] * 1000.0)];
    NSNumber* llTo = [NSNumber numberWithLongLong:(long long)([to timeIntervalSince1970] * 1000.0)];
    
    NSMutableArray *args = [[NSMutableArray alloc] initWithArray:@[dir, llFrom, llTo,]];
    
    NSTimeZone *startTimeZone = [oldTrip startTimeZone];
    NSTimeZone *endTimeZone = [oldTrip endTimeZone];
    
    if (![from isEqualToDate:[oldTrip startDate]]) {
        startTimeZone = [NSTimeZone localTimeZone];
        query = [NSString stringWithFormat:@"%@ , %@ = ? ", query, COLUMN_FROM_TIMEZONE];
        [args addObject:[startTimeZone name]];
    }
    
    if (![to isEqualToDate:[oldTrip endDate]]) {
        endTimeZone = [NSTimeZone localTimeZone];
        query = [NSString stringWithFormat:@"%@ , %@ = ? ", query, COLUMN_TO_TIMEZONE];
        [args addObject:[endTimeZone name]];
    }
    
    query = [NSString stringWithFormat:@"%@ WHERE %@ = ? ", query, COLUMN_NAME];
    [args addObject:[oldTrip name]];
    
    __block WBTrip* trip = nil;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback) {
        BOOL result = [database executeUpdate:query withArgumentsInArray:args];
        
        if (!result) {
            *rollback = YES;
            return;
        }
        
#warning REVIEW: on Android we have oldTrip.getName().equalsIgnoreCase(dir.getName()) that seems incorrect because trip name in sqlite db is case sensitive
        
        if (![[oldTrip name] caseInsensitiveCompare:dir] == NSOrderedSame) {
            if (![[WBDB receipts] replaceParentName:[oldTrip name] to:dir inDatabase:database]) {
                *rollback = YES;
                return;
            }
        }
        
        trip = [[WBTrip alloc]
                initWithName:dir
                price:[oldTrip price]
                startDate:from
                endDate:to
                startTimeZone:startTimeZone
                endTimeZone:endTimeZone
                currency:[oldTrip currency]
                miles:[oldTrip miles]];
        
        [[NSFileManager defaultManager] moveItemAtPath:[oldTrip directoryPath] toPath:[trip directoryPath] error:nil];
    }];
    return trip;
}

-(BOOL) updateTrip:(WBTrip*) trip miles:(double) total {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", TABLE_NAME, COLUMN_MILEAGE, COLUMN_NAME];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:query, [NSNumber numberWithDouble:total], [trip name]];
        [trip setMileage:total];
    }];
    return result;
}

-(BOOL) deleteWithName:(NSString*) name {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_NAME];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        // 'ON DELETE CASCADE' should take care of receipts but doesn't
        result = [database executeUpdate:query, name];
        
        [[WBDB receipts] deleteWithParent:name inDatabase:database];
        
        if (_cachedCount != -1) {
            --_cachedCount;
        }
    }];
    return result;
}

#pragma mark - for another tables

- (NSDecimalNumber *)sumAndUpdatePriceForTrip:(WBTrip *)trip inDatabase:(FMDatabase *)db {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", TABLE_NAME, COLUMN_PRICE, COLUMN_NAME];

    NSDecimalNumber *price = [[WBDB receipts] sumPricesForReceiptsWithParent:[trip name] inDatabase:db];

    if (price) {
        if ([db executeUpdate:query, price, [trip name]]) {
            return price; // sum & update ok
        }
    }
    return nil; // returns nil in case of failure
}

-(int)cachedCount {
    if (_cachedCount == -1) {
        // this shouldn't happen because we select all trips on launch, it's just for safety
        NSLog(@"using cached count when there were no query before, default to 0");
        return 0;
    }
    return _cachedCount;
}

#pragma mark - merge

// NSArray doesn't accept nils so we have to check them
static inline NSObject* checkNil(NSObject* obj) {
    return (obj?obj:[NSNull null]);
}

#warning Updated to import trip comments and time zone
+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB overwrite:(BOOL) overwrite {
    NSLog(@"Merging trips");
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", TABLE_NAME, COLUMN_TO];
    
    FMResultSet* resultSet = [importDB executeQuery:selectQuery];
    
    const int nameIndex = [resultSet columnIndexForName:COLUMN_NAME];
    const int fromIndex = [resultSet columnIndexForName:COLUMN_FROM];
    const int toIndex = [resultSet columnIndexForName:COLUMN_TO];
    const int fromTimeZoneIndex = [resultSet columnIndexForName:COLUMN_FROM_TIMEZONE];
    const int toTimeZoneIndex = [resultSet columnIndexForName:COLUMN_TO_TIMEZONE];
    const int priceIndex = [resultSet columnIndexForName:COLUMN_PRICE];
    const int milesIndex = [resultSet columnIndexForName:COLUMN_MILEAGE];
    
    if (![resultSet next]) {
        return false;
    }
    
    const BOOL hasTimezones = fromTimeZoneIndex > 0 && toTimeZoneIndex > 0;
    
    NSString *insertQuery;
    NSString *insertPrefix = overwrite ? @"INSERT OR REPLACE" : @"INSERT OR IGNORE";
    
    if (hasTimezones) {
        insertQuery = [NSString stringWithFormat:@"%@ INTO %@ (%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?)",
                       insertPrefix, TABLE_NAME,
                       COLUMN_NAME, COLUMN_FROM, COLUMN_TO, COLUMN_PRICE, COLUMN_MILEAGE,
                       COLUMN_FROM_TIMEZONE, COLUMN_TO_TIMEZONE];
    } else {
        insertQuery = [NSString stringWithFormat:@"%@ INTO %@ (%@,%@,%@,%@,%@) VALUES (?,?,?,?,?)",
                       insertPrefix, TABLE_NAME,
                       COLUMN_NAME, COLUMN_FROM, COLUMN_TO, COLUMN_PRICE, COLUMN_MILEAGE];
    }
    
    do {
        
        NSString* name = [resultSet stringForColumnIndex:nameIndex];
        // Backwards compatibility stuff
        // no package name here so we just get directory name
        name = [name lastPathComponent];
        
#warning REVIEW: we get miles as double here - on Android there is 'int'
        
        NSMutableArray *values =
        [@[
           checkNil(name),
           [NSNumber numberWithLongLong:[resultSet longLongIntForColumnIndex:fromIndex]],
           [NSNumber numberWithLongLong:[resultSet longLongIntForColumnIndex:toIndex]],
           checkNil([resultSet stringForColumnIndex:priceIndex]),
           [NSNumber numberWithDouble:[resultSet doubleForColumnIndex:milesIndex]],
           ] mutableCopy];
        
        if (hasTimezones) {
            [values addObject:checkNil([resultSet stringForColumnIndex:fromTimeZoneIndex])];
            [values addObject:checkNil([resultSet stringForColumnIndex:toTimeZoneIndex])];
        }
        
#warning REVIEW: as on Android we ignore insert success, but should it be like this?
        [currDB executeUpdate:insertQuery withArgumentsInArray:values];
        
    } while ([resultSet next]);
    
    return true;
}

#pragma mark - autocomplete

-(NSString*)hintForString:(NSString*) str {
    NSString *q = [NSString stringWithFormat:@"SELECT DISTINCT TRIM(%@) AS _id FROM %@ WHERE %@ LIKE ? ORDER BY %@", COLUMN_NAME, TABLE_NAME, COLUMN_NAME, COLUMN_NAME];
    
    NSString *like = [NSString stringWithFormat:@"%@%%", str];
    
    __block NSString *hint = nil;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:q, like];
        if ([result next]) {
            hint = [result stringForColumn:@"_id"];
        }
    }];
    
    return hint;
}

@end
