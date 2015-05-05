//
//  Database+PaymentMethods.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/objc.h>
#import <FMDB/FMDatabaseAdditions.h>
#import "Database+PaymentMethods.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"

@implementation Database (PaymentMethods)

- (BOOL)createPaymentMethodsTable {
    NSArray *sql = @[@"CREATE TABLE ", PaymentMethodsTable.TABLE_NAME, @" (", PaymentMethodsTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ", PaymentMethodsTable.COLUMN_METHOD, @" TEXT", @");"];
    return [self executeUpdateWithStatementComponents:sql]
            && [self insertDefaultMethods];
}

- (BOOL)insertDefaultMethods {
    return [self insertPaymentMethodWithName:NSLocalizedString(@"Cash", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Check", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Personal Card", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Corporate Card", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"Unspecified", nil)];
}

- (BOOL)insertPaymentMethodWithName:(NSString *)methodName {
    NSString *q = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)", PaymentMethodsTable.TABLE_NAME, PaymentMethodsTable.COLUMN_METHOD];

    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:q, methodName];
    }];

    return result;

    return NO;
}

@end
