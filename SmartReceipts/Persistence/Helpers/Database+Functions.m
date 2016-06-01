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
#import "FetchedModelAdapter.h"

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
        SRLog(@"Execute query:'%@'", countQuery);
        result = (NSUInteger) [db intForQuery:countQuery];
        SRLog(@"Result:%tu", result);
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

- (FetchedModelAdapter *)createAdapterUsingQuery:(DatabaseQueryBuilder *)query forModel:(Class)modelClass {
    return [self createAdapterUsingQuery:query forModel:modelClass associatedModel:nil];
}

- (FetchedModelAdapter *)createAdapterUsingQuery:(DatabaseQueryBuilder *)query forModel:(Class)modelClass associatedModel:(NSObject *)model {
    FetchedModelAdapter *adapter = [[FetchedModelAdapter alloc] initWithDatabase:self];
    [adapter setQuery:query.buildStatement parameters:query.parameters];
    [adapter setModelClass:modelClass];
    [adapter setAssociatedModel:model];
    [adapter fetch];
    return adapter;
}

- (double)executeDoubleQuery:(DatabaseQueryBuilder *)query usingDatabase:(FMDatabase *)database {
    NSString *statement = [query buildStatement];
    NSDictionary *parameters = [query parameters];

    SRLog(@"Execute query: '%@'", statement);
    SRLog(@"With parameters: %@", parameters);

    TICK;

    double result = 0;
    FMResultSet *resultSet = [database executeQuery:statement withParameterDictionary:parameters];

    if ([resultSet next] && [resultSet columnCount] > 0) {
        result = [resultSet doubleForColumnIndex:0];
        [resultSet close];
    }

    TOCK(@"Seconds query time");

    return result;
}

- (NSUInteger)nextAutoGeneratedIDForTable:(NSString *)tableName {
    __block NSUInteger nextID = 0;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        nextID = (NSUInteger) [db intForQuery:@"SELECT seq FROM SQLITE_SEQUENCE WHERE name=?", tableName];
    }];
    if (nextID == 0) {
        nextID = 1;
    } else {
        nextID = nextID + 1;
    }
    return nextID;
}

@end
