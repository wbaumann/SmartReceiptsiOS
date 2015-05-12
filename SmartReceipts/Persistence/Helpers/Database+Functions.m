//
//  Database+Functions.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseAdditions.h>
#import "Database+Functions.h"
#import "Constants.h"
#import "DatabaseQueryBuilder.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "FetchedModel.h"
#import "WBTrip.h"
#import "DatabaseTableNames.h"
#import "WBPreferences.h"

@implementation Database (Functions)

- (BOOL)executeUpdate:(NSString *)sqlStatement {
    SRLog(@"executeUpdate(%@)", sqlStatement);

    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sqlStatement];
    }];
    return result;
}

- (BOOL)executeUpdateWithStatementComponents:(NSArray *)components {
    return [self executeUpdate:[components componentsJoinedByString:@""]];
}

- (NSUInteger)databaseVersion {
    __block NSUInteger version = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        version = (NSUInteger) [db intForQuery:@"PRAGMA user_version"];
    }];
    return version;
}

- (void)setDatabaseVersion:(NSUInteger)version {
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version = %tu", version]];
    }];
}

- (NSUInteger)countRowsInTable:(NSString *)tableName {
    __block NSUInteger result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *countQuery = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
        result = (NSUInteger) [db intForQuery:countQuery];
    }];
    return result;
}

- (BOOL)executeQuery:(DatabaseQueryBuilder *)query {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self executeQuery:query usingDatabase:db];
    }];
    return result;
}

- (BOOL)executeQuery:(DatabaseQueryBuilder *)query usingDatabase:(FMDatabase *)database {
    NSString *statement = [query buildStatement];
    NSDictionary *parameters = [query parameters];

    SRLog(@"Execute update: '%@'", statement);
    SRLog(@"With parameters: %@", parameters);

    return [database executeUpdate:statement withParameterDictionary:parameters];
}

- (NSDecimalNumber *)executeDecimalQuery:(DatabaseQueryBuilder *)query {
    __block NSDecimalNumber *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self executeDecimalQuery:query usingDatabase:db];
    }];

    return result;
}

- (NSDecimalNumber *)executeDecimalQuery:(DatabaseQueryBuilder *)query usingDatabase:(FMDatabase *)db {
    NSString *statement = [query buildStatement];
    NSDictionary *parameters = [query parameters];

    SRLog(@"Execute query: '%@'", statement);
    SRLog(@"With parameters: %@", parameters);

    NSDecimalNumber *result = [NSDecimalNumber zero];
    FMResultSet *resultSet = [db executeQuery:statement withParameterDictionary:parameters];

    if ([resultSet next] && [resultSet columnCount] > 0) {
        NSString *sum = [resultSet stringForColumnIndex:0];
        [resultSet close];
        result = [NSDecimalNumber decimalNumberOrZero:sum];
    }

    return result;
}

- (id <FetchedModel>)executeFetchFor:(Class)fetchedClass withQuery:(DatabaseQueryBuilder *)query {
    SRLog(@"executeFetchFor: %@", NSStringFromClass(fetchedClass));

    NSString *statement = query.buildStatement;
    NSDictionary *parameters = query.parameters;

    SRLog(@"Query: '%@'", statement);
    SRLog(@"Parameters: %@", parameters);
    __block id <FetchedModel> result = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:statement withParameterDictionary:parameters];

        while ([resultSet next]) {
            id <FetchedModel> fetched = (id <FetchedModel>) [[fetchedClass alloc] init];
            [fetched loadDataFromResultSet:resultSet];
            result = fetched;
            break;
        }

        [resultSet close];
    }];

    return result;
}

- (NSString *)selectCurrencyFromTable:(NSString *)tableName currencyColumn:(NSString *)currencyColumn forTrip:(WBTrip *)trip {
    __block NSString *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self selectCurrencyFromTable:tableName currencyColumn:currencyColumn forTrip:trip usingDatabase:db];
    }];

    return result;
}

- (NSString *)selectCurrencyFromTable:(NSString *)tableName currencyColumn:(NSString *)currencyColumn forTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)db {
    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*), %@ FROM (SELECT COUNT(*), %@ FROM %@ WHERE %@ = ? GROUP BY %@ );", currencyColumn, currencyColumn, tableName, ReceiptsTable.COLUMN_PARENT, currencyColumn];

    NSString *curr = MULTI_CURRENCY;

    FMResultSet *resultSet = [db executeQuery:query, trip.name];
    if (resultSet) {
        if ([resultSet next] && [resultSet columnCount] > 0) {
            int cnt = [resultSet intForColumnIndex:0];

            if (cnt == 1) {
                curr = [resultSet stringForColumnIndex:1];
            } else if (cnt == 0) {
                curr = [WBPreferences defaultCurrency];
            }
        }
        [resultSet close];
    }

    return curr;
}

@end
