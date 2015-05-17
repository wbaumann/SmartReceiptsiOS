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
#import "Database+Receipts.h"

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

    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumnIndex:nameIndex];
        //TODO jaanus: fix this
        WBTrip *fetchTrip = [[WBTrip alloc] init];
        [fetchTrip setName:name];
        NSString *curr = [[Database sharedInstance] currencyForTripReceipts:fetchTrip usingDatabase:database];
        ////////

        NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZero:[resultSet stringForColumnIndex:priceIndex]];
        WBTrip *trip = [[WBTrip alloc] init];
        [trip setName:name];
        [trip setPrice:[WBPrice priceWithAmount:price currencyCode:curr]];
        [trip setStartDate:[NSDate dateWithMilliseconds:[resultSet longLongIntForColumnIndex:fromIndex]]];
        [trip setEndDate:[NSDate dateWithMilliseconds:[resultSet longLongIntForColumnIndex:toIndex]]];
        [trip setStartTimeZone:[NSTimeZone timeZoneWithName:[resultSet stringForColumnIndex:fromTimeZoneIndex]]];
        [trip setEndTimeZone:[NSTimeZone timeZoneWithName:[resultSet stringForColumnIndex:toTimeZoneIndex]]];
        [allTrips addObject:trip];
    }

    _cachedCount = (int)[allTrips count];

    // copy to make immutable
    return [allTrips copy];
}

- (NSArray *)selectAll {
    __block NSArray *array = nil;
    [_databaseQueue inDatabase:^(FMDatabase *database) {
        array = [[Database sharedInstance] allTripsUsingDatabase:database];
    }];
    return array;
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
