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
    NSString *statement = [query buildStatement];
    NSDictionary *parameters = [query parameters];

    SRLog(@"Execute update: '%@'", statement);
    SRLog(@"With parameters: %@", parameters);

    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:statement withParameterDictionary:parameters];
    }];
    return result;
}

@end
