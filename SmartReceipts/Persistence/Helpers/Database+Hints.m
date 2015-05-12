//
//  Database+Hints.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMResultSet.h>
#import "Database+Hints.h"
#import "FMDatabase.h"
#import "DatabaseTableNames.h"

@implementation Database (Hints)

- (NSString *)hintForTripBasedOnEntry:(NSString *)entry {
    return [self hintFromTable:TripsTable.TABLE_NAME column:TripsTable.COLUMN_NAME baseOnEntry:entry];
}

- (NSString *)hintForReceiptBasedOnEntry:(NSString *)entry {
    return [self hintFromTable:ReceiptsTable.TABLE_NAME column:ReceiptsTable.COLUMN_NAME baseOnEntry:entry];
}

- (NSString *)hintFromTable:(NSString *)tableName column:(NSString *)columnName baseOnEntry:(NSString *)entry {
    NSString *q = [NSString stringWithFormat:@"SELECT DISTINCT TRIM(%@) AS _id FROM %@ WHERE %@ LIKE ? ORDER BY %@", columnName, tableName, columnName, columnName];

    NSString *like = [NSString stringWithFormat:@"%@%%", entry];

    __block NSString *hint = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:q, like];
        if ([result next]) {
            hint = [result stringForColumn:@"_id"];
        }
    }];
    return hint;
}

@end
