//
//  Database+Distances.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "Database+Distances.h"
#import "DatabaseTableNames.h"
#import "Distance.h"
#import "Database+Functions.h"
#import "DatabaseQueryBuilder.h"
#import "WBTrip.h"
#import "WBPrice.h"
#import "WBCurrency.h"
#import "FetchedModelAdapter.h"
#import "Database+Trips.h"
#import "NSDate+Calculations.h"

@implementation Database (Distances)

- (BOOL)createDistanceTable {
    NSArray *createDistanceTable =
            @[@"CREATE TABLE ", DistanceTable.TABLE_NAME, @" (", //
                    DistanceTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT,", //
                    DistanceTable.COLUMN_PARENT, @" TEXT REFERENCES ", TripsTable.COLUMN_NAME, @" ON DELETE CASCADE,", //
                    DistanceTable.COLUMN_DISTANCE, @" DECIMAL(10, 2) DEFAULT 0.00,", //
                    DistanceTable.COLUMN_LOCATION, @" TEXT,", //
                    DistanceTable.COLUMN_DATE, @" DATE,", //
                    DistanceTable.COLUMN_TIMEZONE, @" TEXT,", //
                    DistanceTable.COLUMN_COMMENT, @" TEXT,", //
                    DistanceTable.COLUMN_RATE_CURRENCY, @" TEXT NOT NULL, ", //
                    DistanceTable.COLUMN_RATE, @" DECIMAL(10, 2) DEFAULT 0.00 );"];
    return [self executeUpdateWithStatementComponents:createDistanceTable];
}

- (BOOL)saveDistance:(Distance *)distance {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self saveDistance:distance usingDatabase:db];
    }];

    return result;
}

- (BOOL)saveDistance:(Distance *)distance usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:DistanceTable.TABLE_NAME];
    [insert addParam:DistanceTable.COLUMN_PARENT value:distance.trip.name];
    [self appendCommonValuesFromDistance:distance toQuery:insert];
    BOOL result = [self executeQuery:insert usingDatabase:database];
    if (result) {
        [self updatePriceOfTrip:distance.trip usingDatabase:database];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidInsertModelNotification object:distance];
        });
    }
    return result;
}

- (FetchedModelAdapter *)fetchedAdapterForDistancesInTrip:(WBTrip *)trip {
    FetchedModelAdapter *adapter = [[FetchedModelAdapter alloc] initWithDatabase:self];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = :parent ORDER BY %@ DESC", DistanceTable.TABLE_NAME, DistanceTable.COLUMN_PARENT, DistanceTable.COLUMN_DATE];
    [adapter setQuery:query parameters:@{@"parent" : trip.name}];
    [adapter setModelClass:[Distance class]];
    [adapter fetch];
    return adapter;
}

- (BOOL)deleteDistance:(Distance *)distance {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:DistanceTable.TABLE_NAME];
    [delete addParam:DistanceTable.COLUMN_ID value:@(distance.objectId)];
    BOOL result = [self executeQuery:delete];
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidDeleteModelNotification object:distance];
        });
    }
    return result;
}

- (BOOL)updateDistance:(Distance *)distance {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:DistanceTable.TABLE_NAME];
    [self appendCommonValuesFromDistance:distance toQuery:update];
    [update where:DistanceTable.COLUMN_ID value:@(distance.objectId)];
    BOOL result = [self executeQuery:update];
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidUpdateModelNotification object:distance];
        });
    }
    return result;
}

- (void)appendCommonValuesFromDistance:(Distance *)distance toQuery:(DatabaseQueryBuilder *)query {
    [query addParam:DistanceTable.COLUMN_DISTANCE value:distance.distance];
    [query addParam:DistanceTable.COLUMN_LOCATION value:distance.location];
    [query addParam:DistanceTable.COLUMN_DATE value:distance.date.milliseconds];
    [query addParam:DistanceTable.COLUMN_TIMEZONE value:distance.timeZone.name];
    [query addParam:DistanceTable.COLUMN_COMMENT value:distance.comment];
    [query addParam:DistanceTable.COLUMN_RATE_CURRENCY value:distance.rate.currency.code];
    [query addParam:DistanceTable.COLUMN_RATE value:distance.rate.amount];
}

- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip {
    __block NSDecimalNumber *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self sumOfDistancesForTrip:trip usingDatabase:db];
    }];

    return result;
}

- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *sumStatement = [DatabaseQueryBuilder sumStatementForTable:DistanceTable.TABLE_NAME];
    [sumStatement setSumColumn:@"distance * rate"];
    [sumStatement where:DistanceTable.COLUMN_PARENT value:trip.name];
    return [self executeDecimalQuery:sumStatement usingDatabase:database];
}

- (NSString *)currencyForTripDistances:(WBTrip *)trip {
    __block NSString *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self currencyForTripDistances:trip usingDatabase:db];
    }];

    return result;
}

- (NSString *)currencyForTripDistances:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    return [self selectCurrencyFromTable:DistanceTable.TABLE_NAME currencyColumn:DistanceTable.COLUMN_RATE_CURRENCY forTrip:trip usingDatabase:database];
}

@end
