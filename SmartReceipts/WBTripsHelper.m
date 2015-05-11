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
#import "WBPrice.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database+Trips.h"
#import "NSDate+Calculations.h"

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
        NSString *name = [resultSet stringForColumnIndex:nameIndex];
        NSString *curr = [[WBDB receipts] selectCurrencyForReceiptsWithParent:name inDatabase:database];
        if (!curr) {
            curr = [WBTrip MULTI_CURRENCY];
        }

        NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumnIndex:priceIndex]];
        WBTrip *trip = [[WBTrip alloc] initWithName:name
                                              price:[WBPrice priceWithAmount:price currencyCode:curr]
                                          startDate:[NSDate dateWithMilliseconds:[resultSet longLongIntForColumnIndex:fromIndex]]
                                            endDate:[NSDate dateWithMilliseconds:[resultSet longLongIntForColumnIndex:toIndex]]
                                      startTimeZone:[NSTimeZone timeZoneWithName:[resultSet stringForColumnIndex:fromTimeZoneIndex]]
                                        endTimeZone:[NSTimeZone timeZoneWithName:[resultSet stringForColumnIndex:toTimeZoneIndex]]
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

- (WBTrip *)insertWithName:(NSString *)name from:(NSDate *)from to:(NSDate *)to {
    name = [name lastPathComponent]; // for removing slashes
    NSString *defaultCurr = [WBPreferences defaultCurrency];
    WBTrip *trip = [[WBTrip alloc] initWithName:name
                                          price:[WBPrice zeroPriceWithCurrencyCode:defaultCurr]
                                      startDate:from
                                        endDate:to
                                  startTimeZone:[NSTimeZone localTimeZone]
                                    endTimeZone:[NSTimeZone localTimeZone]
                                          miles:0];
    [[Database sharedInstance] saveTrip:trip];
    if (_cachedCount != -1) {
        ++_cachedCount;
    }
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
                miles:[oldTrip miles]];

        [[NSFileManager defaultManager] moveItemAtPath:[oldTrip directoryPath] toPath:[trip directoryPath] error:nil];
    }];
    return trip;
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

        [currDB executeUpdate:insertQuery withArgumentsInArray:values];

    } while ([resultSet next]);

    return true;
}

@end
