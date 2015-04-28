//
//  DatabaseUpgradeToVersion12.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseUpgradeToVersion12.h"
#import "DistancesHelper.h"
#import "PaymentMethodsHelper.h"
#import "FMDatabaseQueue+QueueShortcuts.h"

@interface PaymentMethodsHelper (Expose)

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue;

@end

@implementation DatabaseUpgradeToVersion12

- (NSUInteger)version {
    return 12;
}

+ (BOOL)migrateDatabase:(FMDatabaseQueue *)databaseQueue {
    [PaymentMethodsHelper createTableInQueue:databaseQueue];
    NSArray *alterTrips = @[@"ALTER TABLE ", TripsTable.TABLE_NAME, @" ADD ", TripsTable.COLUMN_FILTERS, @" TEXT"];
    [databaseQueue executeUpdateWithStatementComponents:alterTrips];

    NSArray *alterReceipts = @[@"ALTER TABLE ", ReceiptsTable.TABLE_NAME, @" ADD ", ReceiptsTable.COLUMN_PAYMENT_METHOD_ID, @" INTEGER REFERENCES ", PaymentMethodsTable.TABLE_NAME, @" ON DELETE NO ACTION"];
    [databaseQueue executeUpdateWithStatementComponents:alterReceipts];

    return YES;
}

@end
