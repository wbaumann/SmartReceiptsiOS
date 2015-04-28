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

- (BOOL)migrate:(FMDatabaseQueue *)databaseQueue {
    NSArray *alterTrips = @[@"ALTER TABLE ", TripsTable.TABLE_NAME, @" ADD ", TripsTable.COLUMN_FILTERS, @" TEXT"];
    NSArray *alterReceipts = @[@"ALTER TABLE ", ReceiptsTable.TABLE_NAME, @" ADD ", ReceiptsTable.COLUMN_PAYMENT_METHOD_ID, @" INTEGER REFERENCES ", PaymentMethodsTable.TABLE_NAME, @" ON DELETE NO ACTION"];

    return [PaymentMethodsHelper createTableInQueue:databaseQueue]
            && [databaseQueue executeUpdateWithStatementComponents:alterTrips]
            && [databaseQueue executeUpdateWithStatementComponents:alterReceipts];
}

@end
