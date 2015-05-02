//
//  Database+Distances.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "Database+Distances.h"
#import "DatabaseTableNames.h"
#import "Distance.h"
#import "Database+Functions.h"

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
    return NO;
}

@end
