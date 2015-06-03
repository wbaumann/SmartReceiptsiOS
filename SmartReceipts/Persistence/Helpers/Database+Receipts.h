//
//  Database+Receipts.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/objc.h>
#import "Database.h"

@class WBReceipt;
@class WBTrip;
@class FMDatabase;
@class FetchedModelAdapter;

@interface Database (Receipts)

- (BOOL)createReceiptsTable;
- (BOOL)saveReceipt:(WBReceipt *)receipt;
- (BOOL)saveReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database;
- (BOOL)deleteReceipt:(WBReceipt *)receipt;
- (BOOL)deleteReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database;
- (NSArray *)allReceiptsForTrip:(WBTrip *)trip;
- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (NSString *)currencyForTripReceipts:(WBTrip *)trip;
- (NSString *)currencyForTripReceipts:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (BOOL)deleteReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (BOOL)moveReceiptsWithParent:(NSString *)previous toParent:(NSString *)next usingDatabase:(FMDatabase *)database;
- (FetchedModelAdapter *)fetchedReceiptsAdapterForTrip:(WBTrip *)trip;
- (BOOL)updateReceipt:(WBReceipt *)receipt changeFileNameTo:(NSString *)fileName;
- (BOOL)copyReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip;
- (BOOL)moveReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip;
- (BOOL)swapReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo;
- (NSUInteger)nextReceiptID;

@end
