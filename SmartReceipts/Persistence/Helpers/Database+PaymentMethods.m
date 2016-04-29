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
#import "NSString+Helpers.h"

@implementation Database (PaymentMethods)

- (BOOL)createPaymentMethodsTable {
    NSArray *sql = @[@"CREATE TABLE ", PaymentMethodsTable.TABLE_NAME, @" (", PaymentMethodsTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ", PaymentMethodsTable.COLUMN_METHOD, @" TEXT", @");"];
    return [self executeUpdateWithStatementComponents:sql]
            && [self insertDefaultMethods];
}

- (BOOL)insertDefaultMethods {
    return [self insertPaymentMethodWithName:NSLocalizedString(@"payment.method.cash", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"payment.method.check", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"payment.method.personal.card", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"payment.method.corporate.card", nil)]
            && [self insertPaymentMethodWithName:NSLocalizedString(@"payment.method.unspecified", nil)];
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
    return [self createAdapterUsingQuery:selectAll forModel:[PaymentMethod class]];
}

- (BOOL)savePaymentMethod:(PaymentMethod *)method {
    DatabaseQueryBuilder *insertStatement = [DatabaseQueryBuilder insertStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [insertStatement addParam:PaymentMethodsTable.COLUMN_METHOD value:method.method];
    if (method.objectId != 0) {
        [insertStatement addParam:PaymentMethodsTable.COLUMN_ID value:@(method.objectId)];
    }
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

- (NSArray *)allPaymentMethods {
    return [[self fetchedAdapterForPaymentMethods] allObjects];
}

- (PaymentMethod *)paymentMethodById:(NSUInteger)methodId {
    DatabaseQueryBuilder *selectAll = [DatabaseQueryBuilder selectAllStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [selectAll where:PaymentMethodsTable.COLUMN_ID value:@(methodId)];
    return (PaymentMethod *)[self executeFetchFor:[PaymentMethod class] withQuery:selectAll];
}

- (BOOL)hasPaymentMethodWithName:(NSString *)name {
    NSString *checked = [name trimmedString];
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [select where:PaymentMethodsTable.COLUMN_METHOD value:checked caseInsensitive:YES];
    PaymentMethod *method = (PaymentMethod *)[self executeFetchFor:[PaymentMethod class] withQuery:select];
    return method != nil;
}

- (PaymentMethod *)methodById:(NSUInteger)methodId {
    DatabaseQueryBuilder *fetch = [DatabaseQueryBuilder selectAllStatementForTable:PaymentMethodsTable.TABLE_NAME];
    [fetch where:PaymentMethodsTable.COLUMN_ID value:@(methodId)];
    return (PaymentMethod *)[self executeFetchFor:[PaymentMethod class] withQuery:fetch];
}

@end
