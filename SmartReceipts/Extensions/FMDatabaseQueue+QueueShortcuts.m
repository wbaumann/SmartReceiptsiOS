//
//  FMDatabaseQueue+QueueShortcuts.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "FMDatabaseQueue+QueueShortcuts.h"
#import "Constants.h"
#import "FMDatabaseAdditions.h"

@implementation FMDatabaseQueue (QueueShortcuts)

- (BOOL)executeUpdate:(NSString *)sqlStatement {
    SRLog(@"executeUpdate(%@)", sqlStatement);

    __block BOOL result;
    [self inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sqlStatement];
    }];
    return result;
}

- (BOOL)executeUpdateWithStatementComponents:(NSArray *)components {
    return [self executeUpdate:[components componentsJoinedByString:@""]];
}

- (NSUInteger)databaseVersion {
    __block NSUInteger version = 0;
    [self inDatabase:^(FMDatabase *db) {
        version = (NSUInteger) [db intForQuery:@"PRAGMA user_version"];
    }];
    return version;
}

- (void)setDatabaseVersion:(NSUInteger)version {
    [self inDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version = %d", version]];
    }];
}

@end
