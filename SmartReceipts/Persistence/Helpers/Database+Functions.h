//
//  Database+Functions.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class DatabaseQueryBuilder;
@protocol FetchedModel;
@class WBTrip;

@interface Database (Functions)

- (BOOL)executeUpdate:(NSString *)sqlStatement;
- (BOOL)executeUpdateWithStatementComponents:(NSArray *)components;
- (NSUInteger)databaseVersion;
- (void)setDatabaseVersion:(NSUInteger)version;
- (NSUInteger)countRowsInTable:(NSString *)tableName;
- (BOOL)executeQuery:(DatabaseQueryBuilder *)query;
- (NSDecimalNumber *)executeDecimalQuery:(DatabaseQueryBuilder *)query;
- (id<FetchedModel>)executeFetchFor:(Class)fetchedClass withQuery:(DatabaseQueryBuilder *)query;
- (NSString *)selectCurrencyFromTable:(NSString *)tableName currencyColumn:(NSString *)currencyColumn forTrip:(WBTrip *)trip;

@end
