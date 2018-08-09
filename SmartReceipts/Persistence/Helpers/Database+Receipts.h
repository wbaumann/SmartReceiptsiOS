//
//  Database+Receipts.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

extern NSInteger const kDaysToOrderFactor;

@class WBReceipt;
@class WBTrip;
@class FMDatabase;
@class FetchedModelAdapter;
@class Currency;

@interface Database (Receipts)

- (BOOL)createReceiptsTable;
- (BOOL)saveReceipt:(WBReceipt *)receipt;
- (BOOL)insertReceipt:(WBReceipt *)receipt;
- (BOOL)saveReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database;
- (BOOL)deleteReceipt:(WBReceipt *)receipt;
- (BOOL)deleteReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database;
- (NSArray *)allReceiptsForTrip:(WBTrip *)trip;
- (NSArray *)allReceiptsForTrip:(WBTrip *)trip ascending:(BOOL)isAscending;
- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (BOOL)deleteReceiptsForTrip:(WBTrip *)trip;
- (BOOL)deleteReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (BOOL)moveReceiptsWithParent:(NSString *)previous toParent:(NSString *)next usingDatabase:(FMDatabase *)database;
- (FetchedModelAdapter *)fetchedReceiptsAdapterForTrip:(WBTrip *)trip;
- (BOOL)updateReceipt:(WBReceipt *)receipt changeFileNameTo:(NSString *)fileName;
- (BOOL)copyReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip;
- (BOOL)moveReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip;
- (BOOL)swapReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo;
- (BOOL)reorderReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo;
- (NSInteger)receiptsCountInOrderIdGroup:(NSInteger)idGroup;
- (NSInteger)receiptsCountInOrderIdGroup:(NSInteger)idGroup usingDatabase:(FMDatabase *)database;
- (NSUInteger)nextReceiptID;
- (WBReceipt *)receiptByObjectID:(NSUInteger)objectID;
- (BOOL)markAllReceiptsSynced:(BOOL)synced;

/**
 Recent currencies
 Returns most recently used currencies, ordered

 @return Array of Currency objects
 */
- (NSArray<Currency *> *)recentCurrencies;

@end
