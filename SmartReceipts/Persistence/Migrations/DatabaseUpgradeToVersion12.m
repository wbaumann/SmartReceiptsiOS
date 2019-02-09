//
//  DatabaseUpgradeToVersion12.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DatabaseUpgradeToVersion12.h"
#import "DatabaseTableNames.h"
#import "Database.h"
#import "Database+PaymentMethods.h"
#import "Database+Functions.h"

@implementation DatabaseUpgradeToVersion12

- (NSUInteger)version {
    return 12;
}

- (BOOL)migrate:(Database *)database {
    [AnalyticsManager.sharedManager recordWithEvent:[Event startDatabaseUpgrade:self.version]];
    
    NSArray *alterTrips = @[@"ALTER TABLE ", TripsTable.TABLE_NAME, @" ADD ", TripsTable.COLUMN_FILTERS, @" TEXT"];
    NSArray *alterReceipts = @[@"ALTER TABLE ", ReceiptsTable.TABLE_NAME, @" ADD ", ReceiptsTable.COLUMN_PAYMENT_METHOD_ID, @" INTEGER REFERENCES ", PaymentMethodsTable.TABLE_NAME, @" ON DELETE NO ACTION"];

    BOOL result = [database createPaymentMethodsTable]
            && [database executeUpdateWithStatementComponents:alterTrips]
            && [database executeUpdateWithStatementComponents:alterReceipts];
    
    [AnalyticsManager.sharedManager recordWithEvent:[Event finishDatabaseUpgrade:self.version success:result]];
    
    return result;
}

@end
