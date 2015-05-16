//
//  Database+Trips.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 07/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabase.h>
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
#import "NSDate+Calculations.h"

@interface WBTrip (Expose)

@property (nonatomic, copy) NSString *originalName;

- (BOOL)nameChanged;
- (NSString *)directoryPathUsingName:(NSString *)name;

@end

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
    [self appendParamsFromTrip:trip toQuery:insert];
    BOOL result = [self executeQuery:insert];
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidInsertModelNotification object:trip];
        });
    }
    return result;
}

- (BOOL)updateTrip:(WBTrip *)trip {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:TripsTable.TABLE_NAME];
    [self appendParamsFromTrip:trip toQuery:update];
    [update where:TripsTable.COLUMN_NAME value:trip.originalName];

    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self executeQuery:update usingDatabase:db];
        if (trip.nameChanged) {
            DatabaseQueryBuilder *updateReceipts = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
            [updateReceipts addParam:ReceiptsTable.COLUMN_PARENT value:trip.name];
            [updateReceipts where:ReceiptsTable.COLUMN_PARENT value:trip.originalName];

            result = [self executeQuery:updateReceipts usingDatabase:db] && result;

            [[NSFileManager defaultManager] moveItemAtPath:[trip directoryPathUsingName:trip.originalName] toPath:[trip directoryPath] error:nil];
        }
    }];

    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidUpdateModelNotification object:trip];
        });
    }

    return result;
}

- (void)appendParamsFromTrip:(WBTrip *)trip toQuery:(DatabaseQueryBuilder *)query {
    [query addParam:TripsTable.COLUMN_NAME value:trip.name];
    [query addParam:TripsTable.COLUMN_FROM value:trip.startDate.milliseconds];
    [query addParam:TripsTable.COLUMN_TO value:trip.endDate.milliseconds];
    [query addParam:TripsTable.COLUMN_FROM_TIMEZONE value:trip.startTimeZone.name];
    [query addParam:TripsTable.COLUMN_TO_TIMEZONE value:trip.endTimeZone.name];
    [query addParam:TripsTable.COLUMN_PRICE value:trip.price.amount];
    [query addParam:TripsTable.COLUMN_DEFAULT_CURRENCY value:trip.defaultCurrency.code];
    [query addParam:TripsTable.COLUMN_COMMENT value:trip.comment];
    [query addParam:TripsTable.COLUMN_COST_CENTER value:trip.costCenter];
}

- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip {
    __block NSDecimalNumber *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self totalPriceForTrip:trip usingDatabase:db];
    }];

    return result;
}

- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    NSDecimalNumber *priceOfTrip = [self sumOfReceiptsForTrip:trip usingDatabase:database];
    if ([WBPreferences isTheDistancePriceBeIncludedInReports]) {
        priceOfTrip = [priceOfTrip decimalNumberByAdding:[self sumOfDistancesForTrip:trip usingDatabase:database]];
    }

    return priceOfTrip;
}

- (NSArray *)allTrips {
    __block NSArray *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self allTripsUsingDatabase:db];
    }];

    return result;
}

- (NSArray *)allTripsUsingDatabase:(FMDatabase *)database {
    FetchedModelAdapter *adapter = [[FetchedModelAdapter alloc] initWithDatabase:self];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", TripsTable.TABLE_NAME, TripsTable.COLUMN_TO];
    [adapter setQuery:query];
    [adapter setModelClass:[WBTrip class]];
    [adapter fetchUsingDatabase:database];
    return [adapter allObjects];
}

- (FetchedModelAdapter *)fetchedAdapterForAllTrips {
    DatabaseQueryBuilder *selectAllTrips = [DatabaseQueryBuilder selectAllStatementForTable:TripsTable.TABLE_NAME];
    [selectAllTrips orderBy:TripsTable.COLUMN_TO ascending:NO];
    return [self createAdapterUsingQuery:selectAllTrips forModel:[WBTrip class]];
}

- (WBTrip *)tripWithName:(NSString *)tripName {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:TripsTable.TABLE_NAME];
    [select where:TripsTable.COLUMN_NAME value:tripName];
    return (WBTrip *)[self executeFetchFor:[WBTrip class] withQuery:select];
}

- (WBPrice *)updatePriceOfTrip:(WBTrip *)trip {
    __block WBPrice *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self updatePriceOfTrip:trip usingDatabase:db];
    }];

    return result;
}

- (WBPrice *)updatePriceOfTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    WBPrice *price = [self tripPrice:trip usingDatabase:database];

    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:TripsTable.TABLE_NAME];
    [update addParam:TripsTable.COLUMN_PRICE value:price.amount];
    [update addParam:TripsTable.COLUMN_DEFAULT_CURRENCY value:price.currency.code];
    [update where:TripsTable.COLUMN_NAME value:trip.name];

    [self executeQuery:update usingDatabase:database];

    return price;
}

- (WBPrice *)tripPrice:(WBTrip *)trip {
    __block WBPrice *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self tripPrice:trip usingDatabase:db];
    }];

    return result;
}

- (WBPrice *)tripPrice:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    NSDecimalNumber *total = [self totalPriceForTrip:trip usingDatabase:database];
    NSString *currencyCode = [self aggregateCurrencyCodeForTrip:trip usingDatabase:database];

    return [WBPrice priceWithAmount:total currencyCode:currencyCode];
}

- (NSString *)aggregateCurrencyCodeForTrip:(WBTrip *)trip {
    __block NSString *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self aggregateCurrencyCodeForTrip:trip usingDatabase:db];
    }];

    return result;
}

- (NSString *)aggregateCurrencyCodeForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    NSString *receiptsCurrency = [self currencyForTripReceipts:trip usingDatabase:database];
    if ([MULTI_CURRENCY isEqualToString:receiptsCurrency]) {
        return receiptsCurrency;
    }

    if (![WBPreferences isTheDistancePriceBeIncludedInReports]) {
        return receiptsCurrency;
    }

    NSString *distancesCurrency = [self currencyForTripDistances:trip usingDatabase:database];
    if ([receiptsCurrency isEqualToString:distancesCurrency]) {
        return receiptsCurrency;
    }

    return MULTI_CURRENCY;
}

@end
