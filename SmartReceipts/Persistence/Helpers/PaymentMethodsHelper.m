//
//  PaymentMethodsHelper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabaseAdditions.h>
#import "PaymentMethodsHelper.h"
#import "Database.h"
#import "FMDatabaseQueue+QueueShortcuts.h"

@implementation PaymentMethodsHelper

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue {
    NSArray *sql = @[@"CREATE TABLE ", PaymentMethodsTable.TABLE_NAME, @" (", PaymentMethodsTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ", PaymentMethodsTable.COLUMN_METHOD, @" TEXT", @");"];
    return [queue executeUpdateWithStatementComponents:sql]
            && [self insertDefaultMethodsIntoQueue:queue];
}

+ (BOOL)insertDefaultMethodsIntoQueue:(FMDatabaseQueue *)queue {
    return [self insertPaymentMethodWithName:NSLocalizedString(@"Cash", nil) intoQueue:queue]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Check", nil) intoQueue:queue]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Personal Card", nil) intoQueue:queue]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Corporate Card", nil) intoQueue:queue]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Unspecified", nil) intoQueue:queue];
}

+ (BOOL)insertPaymentMethodWithName:(NSString *)methodName intoQueue:(FMDatabaseQueue *)queue {
    NSString *q = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)", PaymentMethodsTable.TABLE_NAME, PaymentMethodsTable.COLUMN_METHOD];

    __block BOOL result;
    [queue inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:q, methodName];
    }];

    return result;

    return NO;
}

@end
