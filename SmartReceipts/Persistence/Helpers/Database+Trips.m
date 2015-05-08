//
//  Database+Trips.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 07/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Trips.h"
#import "WBTrip.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "DatabaseQueryBuilder.h"
#import "WBPrice.h"
#import "WBCurrency.h"
#import "Database+Receipts.h"
#import "WBPreferences.h"
#import "Database+Distances.h"
#import "FetchedModelAdapter.h"

@implementation Database (Trips)

- (BOOL)createTripsTable {
    NSArray *createTripsTable = @[
            @"CREATE TABLE ", TripsTable.TABLE_NAME, @" (",
            TripsTable.COLUMN_NAME, @" TEXT PRIMARY KEY, ",
            TripsTable.COLUMN_FROM, @" DATE, ",
            TripsTable.COLUMN_TO, @" DATE, ",
            TripsTable.COLUMN_FROM_TIMEZONE, @" TEXT, ",
            TripsTable.COLUMN_TO_TIMEZONE, @" TEXT, ",
            TripsTable.COLUMN_PRICE, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            TripsTable.COLUMN_MILEAGE, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            TripsTable.COLUMN_COMMENT, @" TEXT, ",
            TripsTable.COLUMN_DEFAULT_CURRENCY, @" TEXT",
            @");"];
    return [self executeUpdateWithStatementComponents:createTripsTable];
}

- (BOOL)saveTrip:(WBTrip *)trip {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:TripsTable.TABLE_NAME];
    [insert addParam:TripsTable.COLUMN_NAME value:trip.name];
    [insert addParam:TripsTable.COLUMN_FROM value:trip.startDate];
    [insert addParam:TripsTable.COLUMN_TO value:trip.endDate];
    [insert addParam:TripsTable.COLUMN_FROM_TIMEZONE value:trip.startTimeZone.name];
    [insert addParam:TripsTable.COLUMN_TO_TIMEZONE value:trip.endTimeZone.name];
    [insert addParam:TripsTable.COLUMN_PRICE value:trip.price.amount];
    [insert addParam:TripsTable.COLUMN_DEFAULT_CURRENCY value:trip.price.currency.code];
    BOOL result = [self executeQuery:insert];
    return result;
}

- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip {
    NSDecimalNumber *priceOfTrip = [self sumOfReceiptsForTrip:trip];
    if ([WBPreferences isTheDistancePriceBeIncludedInReports]) {
        priceOfTrip = [priceOfTrip decimalNumberByAdding:[self sumOfDistancesForTrip:trip]];
    }

    return priceOfTrip;
}

- (NSArray *)allTrips {
    FetchedModelAdapter *adapter = [[FetchedModelAdapter alloc] initWithDatabase:self];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", TripsTable.TABLE_NAME, TripsTable.COLUMN_TO];
    [adapter setQuery:query];
    [adapter setModelClass:[WBTrip class]];
    [adapter fetch];
    return [adapter allObjects];
}

- (WBTrip *)tripWithName:(NSString *)tripName {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:TripsTable.TABLE_NAME];
    [select where:TripsTable.COLUMN_NAME value:tripName];
    return [self executeFetchFor:[WBTrip class] withQuery:select];
}

@end
