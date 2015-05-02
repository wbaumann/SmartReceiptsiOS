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
        [db executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version = %lu", version]];
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

@end
