//
//  DatabaseUpgradeToVersion13.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "DatabaseUpgradeToVersion13.h"
#import "DistancesHelper.h"
#import "FMDatabaseQueue+QueueShortcuts.h"
#import "WBPreferences.h"

@interface DistancesHelper (Expose)

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue;

@end

@implementation DatabaseUpgradeToVersion13

- (NSUInteger)version {
    return 13;
}

- (BOOL)migrate:(FMDatabaseQueue *)databaseQueue {
    NSArray *distanceMigrateBase = @[@"INSERT INTO ", DistanceTable.TABLE_NAME, @"(", DistanceTable.COLUMN_PARENT, @", ", DistanceTable.COLUMN_DISTANCE, @", ", DistanceTable.COLUMN_LOCATION, @", ", DistanceTable.COLUMN_DATE, @", ", DistanceTable.COLUMN_TIMEZONE, @", ", DistanceTable.COLUMN_COMMENT, @", ", DistanceTable.COLUMN_RATE_CURRENCY, @")",
            @" SELECT ", TripsTable.COLUMN_NAME, @", ", TripsTable.COLUMN_MILEAGE, @" , \"\" as ", DistanceTable.COLUMN_LOCATION, @", ", TripsTable.COLUMN_FROM, @", ", TripsTable.COLUMN_FROM_TIMEZONE, @" , \"\" as ", DistanceTable.COLUMN_COMMENT, @", "];

    NSArray *distanceMigrateNotNullCurrency = [distanceMigrateBase arrayByAddingObjectsFromArray:@[TripsTable.COLUMN_DEFAULT_CURRENCY, @" FROM ", TripsTable.TABLE_NAME, @" WHERE ", TripsTable.COLUMN_DEFAULT_CURRENCY, @" IS NOT NULL AND ", TripsTable.COLUMN_MILEAGE, @" > 0;"]];
    NSArray *distanceMigrateNullCurrency = [distanceMigrateBase arrayByAddingObjectsFromArray:@[@"\"", [WBPreferences defaultCurrency], @"\" as ", DistanceTable.COLUMN_RATE_CURRENCY, @" FROM ", TripsTable.TABLE_NAME, @" WHERE ", TripsTable.COLUMN_DEFAULT_CURRENCY, @" IS NULL AND ", TripsTable.COLUMN_MILEAGE, @" > 0;"]];
    NSArray *alterTripsWithCostCenter = @[@"ALTER TABLE ", TripsTable.TABLE_NAME, @" ADD ", TripsTable.COLUMN_COST_CENTER, @" TEXT"];
    NSArray *alterTripsWithProcessingStatus = @[@"ALTER TABLE ", TripsTable.TABLE_NAME, @" ADD ", TripsTable.COLUMN_PROCESSING_STATUS, @" TEXT"];
    NSArray *alterReceiptsWithProcessingStatus = @[@"ALTER TABLE ", ReceiptsTable.TABLE_NAME, @" ADD ", ReceiptsTable.COLUMN_PROCESSING_STATUS, @" TEXT"];

    return [DistancesHelper createTableInQueue:databaseQueue]
            && [databaseQueue executeUpdateWithStatementComponents:distanceMigrateNotNullCurrency]
            && [databaseQueue executeUpdateWithStatementComponents:distanceMigrateNullCurrency]
            && [databaseQueue executeUpdateWithStatementComponents:alterTripsWithCostCenter]
            && [databaseQueue executeUpdateWithStatementComponents:alterTripsWithProcessingStatus]
            && [databaseQueue executeUpdateWithStatementComponents:alterReceiptsWithProcessingStatus];
}

@end
