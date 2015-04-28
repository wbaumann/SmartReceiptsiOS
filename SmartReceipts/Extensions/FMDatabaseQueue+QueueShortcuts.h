//
//  FMDatabaseQueue+QueueShortcuts.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "FMDatabaseQueue.h"

@interface FMDatabaseQueue (QueueShortcuts)

- (BOOL)executeUpdate:(NSString *)sqlStatement;
- (BOOL)executeUpdateWithStatementComponents:(NSArray *)components;
- (NSUInteger)databaseVersion;
- (void)setDatabaseVersion:(NSUInteger)version;
- (NSUInteger)countRowsInTable:(NSString *)tableName;

@end
