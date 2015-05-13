//
//  Database+PaymentMethods.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseAdditions.h>
#import "Database+PaymentMethods.h"
#import "DatabaseTableNames.h"
#import "FetchedModelAdapter.h"
#import "Database+Functions.h"
#import "DatabaseQueryBuilder.h"
#import "PaymentMethod.h"

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

- (FetchedModelAdapter *)fetchedAdapterForPaymentMethods {
    DatabaseQueryBuilder *selectAll = [DatabaseQueryBuilder selectAllStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [selectAll orderBy:PaymentMethodsTable.COLUMN_METHOD ascending:YES];
    return [self createAdapterUsingQuery:selectAll forMode:[PaymentMethod class]];
}

- (BOOL)savePaymentMethod:(PaymentMethod *)method {
    DatabaseQueryBuilder *insertStatement = [DatabaseQueryBuilder insertStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [insertStatement addParam:PaymentMethodsTable.COLUMN_METHOD value:method.method];
    BOOL result = [self executeQuery:insertStatement];
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidInsertModelNotification object:method];
        });
    }
    return result;
}

- (BOOL)updatePaymentMethod:(PaymentMethod *)method {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [update addParam:PaymentMethodsTable.COLUMN_METHOD value:method.method];
    [update where:PaymentMethodsTable.COLUMN_ID value:@(method.objectId)];
    BOOL result = [self executeQuery:update];
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidUpdateModelNotification object:method];
        });
    }
    return result;
}

- (BOOL)deletePaymentMethod:(PaymentMethod *)method {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [delete where:PaymentMethodsTable.COLUMN_ID value:@(method.objectId)];
    BOOL result = [self executeQuery:delete];
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseDidDeleteModelNotification object:method];
        });
    }
    return result;
}

- (PaymentMethod *)methodById:(NSUInteger)methodId {
    DatabaseQueryBuilder *fetch = [DatabaseQueryBuilder selectAllStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [fetch where:PaymentMethodsTable.COLUMN_ID value:@(methodId)];
    return (PaymentMethod *)[self executeFetchFor:[PaymentMethod class] withQuery:fetch];
}

@end
