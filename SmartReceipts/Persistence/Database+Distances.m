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
#import "Price.h"
#import "FetchedModelAdapter.h"
#import "Database+Trips.h"
#import "NSDate+Calculations.h"
#import "Database+Notify.h"
#import "WBPreferences.h"
#import <SmartReceipts-Swift.h>

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
    BOOL result;
    if (distance.objectId == 0) {
        result = [self insertDistance:distance usingDatabase:database];
    } else {
        result = [self updateDistance:distance usingDatabase:database];
    }

    [self notifyUpdateOfModel:distance.trip];
    return result ;
}

- (BOOL)insertDistance:(Distance *)distance usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:DistanceTable.TABLE_NAME];
    [insert addParam:DistanceTable.COLUMN_PARENT value:distance.trip.name];
    [self appendCommonValuesFromDistance:distance toQuery:insert];
    BOOL result = [self executeQuery:insert usingDatabase:database];
    if (result) {
        [self notifyInsertOfModel:distance];
    }
    return result;
}

- (FetchedModelAdapter *)fetchedAdapterForDistancesInTrip:(WBTrip *)trip {
    return [self fetchedAdapterForDistancesInTrip:trip ascending:NO];
}

- (FetchedModelAdapter *)fetchedAdapterForDistancesInTrip:(WBTrip *)trip ascending:(BOOL)isAscending {
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:DistanceTable.TABLE_NAME];
    [select where:DistanceTable.COLUMN_PARENT value:trip.name];
    [select orderBy:DistanceTable.COLUMN_DATE ascending:isAscending];
    return [self createAdapterUsingQuery:select forModel:[Distance class] associatedModel:trip];
}

- (BOOL)deleteDistance:(Distance *)distance {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self deleteDistance:distance usingDatabase:db];
    }];

    return result;
}

- (BOOL)deleteDistance:(Distance *)distance usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:DistanceTable.TABLE_NAME];
    [delete where:DistanceTable.COLUMN_ID value:@(distance.objectId)];
    BOOL result = [self executeQuery:delete usingDatabase:database];
    if (result) {
        [self notifyDeleteOfModel:distance];
        [self notifyUpdateOfModel:distance.trip];
    }
    return result;
}

- (BOOL)updateDistance:(Distance *)distance usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:DistanceTable.TABLE_NAME];
    [self appendCommonValuesFromDistance:distance toQuery:update];
    [update where:DistanceTable.COLUMN_ID value:@(distance.objectId)];
    BOOL result = [self executeQuery:update usingDatabase:database];
    if (result) {
        [self notifyUpdateOfModel:distance];
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

- (NSArray *)allDistancesForTrip:(WBTrip *)trip {
    return [[self fetchedAdapterForDistancesInTrip:trip] allObjects];
}

- (BOOL)deleteDistancesForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:DistanceTable.TABLE_NAME];
    [delete where:DistanceTable.COLUMN_PARENT value:trip.name];
    return [self executeQuery:delete usingDatabase:database];
}

- (BOOL)moveDistancesWithParent:(NSString *)previous toParent:(NSString *)next usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:DistanceTable.TABLE_NAME];
    [update addParam:DistanceTable.COLUMN_PARENT value:next];
    [update where:DistanceTable.COLUMN_PARENT value:previous];
    return [self executeQuery:update usingDatabase:database];
}

- (NSDecimalNumber *)totalDistanceTraveledForTrip:(WBTrip *)trip {
    DatabaseQueryBuilder *sum = [DatabaseQueryBuilder sumStatementForTable:DistanceTable.TABLE_NAME];
    [sum setSumColumn:DistanceTable.COLUMN_DISTANCE];
    [sum where:DistanceTable.COLUMN_PARENT value:trip.name];
    return [self executeDecimalQuery:sum];
}

@end
