//
//  Database+Receipts.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "Database+Receipts.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "WBReceipt.h"
#import "DatabaseQueryBuilder.h"
#import "WBTrip.h"
#import "WBCurrency.h"
#import "Price.h"
#import "FetchedModelAdapter.h"
#import "WBPreferences.h"
#import "Database+Trips.h"
#import "Database+PaymentMethods.h"
#import "PaymentMethod.h"
#import "Database+Notify.h"
#import "ReceiptFilesManager.h"
#import "NSDate+Calculations.h"
#import "Constants.h"
#import "SmartReceipts-Swift.h"

@interface WBReceipt (Expose)

- (BOOL)dateChanged;

@end

@implementation Database (Receipts)

- (BOOL)createReceiptsTable {
    NSArray *createReceiptsTable = @[
            @"CREATE TABLE ", ReceiptsTable.TABLE_NAME, @" (",
            ReceiptsTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ",
            ReceiptsTable.COLUMN_PATH, @" TEXT, ",
            ReceiptsTable.COLUMN_PARENT, @" TEXT REFERENCES ", TripsTable.TABLE_NAME, @" ON DELETE CASCADE, ",
            ReceiptsTable.COLUMN_NAME, @" TEXT DEFAULT \"New Receipt\", ",
            ReceiptsTable.COLUMN_CATEGORY, @" TEXT, ",
            ReceiptsTable.COLUMN_DATE, @" DATE DEFAULT (DATE('now', 'localtime')), ",
            ReceiptsTable.COLUMN_TIMEZONE, @" TEXT, ",
            ReceiptsTable.COLUMN_COMMENT, @" TEXT, ",
            ReceiptsTable.COLUMN_ISO4217, @" TEXT NOT NULL, ",
            ReceiptsTable.COLUMN_PRICE, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            ReceiptsTable.COLUMN_TAX, @" DECIMAL(10, 2) DEFAULT 0.00, ",
            ReceiptsTable.COLUMN_PAYMENTMETHOD, @" TEXT, ",
            ReceiptsTable.COLUMN_EXPENSEABLE, @" BOOLEAN DEFAULT 1, ",
            ReceiptsTable.COLUMN_NOTFULLPAGEIMAGE, @" BOOLEAN DEFAULT 1, ",
            ReceiptsTable.COLUMN_EXTRA_EDITTEXT_1, @" TEXT, ",
            ReceiptsTable.COLUMN_EXTRA_EDITTEXT_2, @" TEXT, ",
            ReceiptsTable.COLUMN_EXTRA_EDITTEXT_3, @" TEXT",
            @");"];
    return [self executeUpdateWithStatementComponents:createReceiptsTable];
}

- (BOOL)saveReceipt:(WBReceipt *)receipt {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self saveReceipt:receipt usingDatabase:db];
    }];

    return result;
}

- (BOOL)saveReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    if (receipt.objectId == 0) {
        return [self insertReceipt:receipt usingDatabase:database];
    } else {
        return [self updateReceipt:receipt usingDatabase:database];
    }
}

- (BOOL)insertReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:ReceiptsTable.TABLE_NAME];
    [self appendCommonValuesFromReceipt:receipt toQuery:insert];

    NSDate *modifiedInsertDate = [self dateWithSecondsModifiedForTrip:receipt.trip basedOnDate:receipt.date usingDatabase:database];
    [insert addParam:ReceiptsTable.COLUMN_DATE value:modifiedInsertDate.milliseconds];

    BOOL result = [self executeQuery:insert usingDatabase:database];
    if (result) {
        [self notifyInsertOfModel:receipt];
        [self notifyUpdateOfModel:receipt.trip];
    }
    return result;
}

- (BOOL)updateReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [self appendCommonValuesFromReceipt:receipt toQuery:update];
    if (receipt.dateChanged) {
        NSDate *modifiedInsertDate = [self dateWithSecondsModifiedForTrip:receipt.trip basedOnDate:receipt.date usingDatabase:database];
        [update addParam:ReceiptsTable.COLUMN_DATE value:modifiedInsertDate.milliseconds];
    }
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    BOOL result = [self executeQuery:update usingDatabase:database];
    if (result) {
        [self notifyUpdateOfModel:receipt];
        [self notifyUpdateOfModel:receipt.trip];
    }
    return result;
}

- (NSDate *)dateWithSecondsModifiedForTrip:(WBTrip *)trip basedOnDate:(NSDate *)date usingDatabase:(FMDatabase *)database {
    // Do some second magic for insert order. This should give always unique receipt time
    NSTimeInterval secondsToAdd = [self maxSecondForReceiptsInTrip:trip onDate:date usingDatabase:database] + 1;
    return [date.dateAtBeginningOfDay dateByAddingTimeInterval:secondsToAdd];
}

- (BOOL)deleteReceipt:(WBReceipt *)receipt {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self deleteReceipt:receipt usingDatabase:db];
    }];

    return result;
}

- (BOOL)deleteReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:ReceiptsTable.TABLE_NAME];
    [delete where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    BOOL result = [self executeQuery:delete usingDatabase:database];
    if (result) {
        [self.filesManager deleteFileForReceipt:receipt];
        [self notifyDeleteOfModel:receipt];
        [self notifyUpdateOfModel:receipt.trip];
    }
    return result;
}

- (NSArray *)allReceiptsForTrip:(WBTrip *)trip {
    return [self allReceiptsForTrip:trip ascending:false];
}

- (NSArray *)allReceiptsForTrip:(WBTrip *)trip ascending:(BOOL)isAscending {
    DatabaseQueryBuilder *selectAll = [WBReceipt selectAllQueryForTrip:trip isAscending:isAscending];
    return [self allReceiptsWithQuery:selectAll forTrip:trip];
}

- (NSArray *)allReceiptsWithQuery:(DatabaseQueryBuilder *)query forTrip:(WBTrip *)trip {
    FetchedModelAdapter *adapter = [self createAdapterUsingQuery:query forModel:[WBReceipt class] associatedModel:trip];
    NSArray *receipts = [adapter allObjects];
    return receipts;
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    return [self sumOfReceiptsForTrip:trip onlyExpenseableReceipts:[WBPreferences onlyIncludeExpensableReceiptsInReports] usingDatabase:database];
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip onlyExpenseableReceipts:(BOOL)onlyExpenseable {
    __block NSDecimalNumber *result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self sumOfReceiptsForTrip:trip onlyExpenseableReceipts:onlyExpenseable usingDatabase:db];
    }];

    return result;
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip onlyExpenseableReceipts:(BOOL)onlyExpenseable usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *sumStatement = [DatabaseQueryBuilder sumStatementForTable:ReceiptsTable.TABLE_NAME];
    [sumStatement setSumColumn:ReceiptsTable.COLUMN_PRICE];
    [sumStatement where:ReceiptsTable.COLUMN_PARENT value:trip.name];
    if (onlyExpenseable) {
        [sumStatement where:ReceiptsTable.COLUMN_EXPENSEABLE value:@(YES)];
    }
    return [self executeDecimalQuery:sumStatement usingDatabase:database];
}

+ (NSString *)extraInsertValue:(NSString *)extraValue {
    if (!extraValue) {
        return SRNoData;
    } else {
        if ([extraValue caseInsensitiveCompare:@"null"] == NSOrderedSame) {
            return @"";
        }
    }

    return extraValue;
}

- (BOOL)deleteReceiptsForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *delete = [DatabaseQueryBuilder deleteStatementForTable:ReceiptsTable.TABLE_NAME];
    [delete where:ReceiptsTable.COLUMN_PARENT value:trip.name];
    return [self executeQuery:delete usingDatabase:database];
}

- (BOOL)moveReceiptsWithParent:(NSString *)previous toParent:(NSString *)next usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_PARENT value:next];
    [update where:ReceiptsTable.COLUMN_PARENT value:previous];
    return [self executeQuery:update usingDatabase:database];
}

- (FetchedModelAdapter *)fetchedReceiptsAdapterForTrip:(WBTrip *)trip {
    NSString *receiptIdFullName = [NSString stringWithFormat:@"%@.%@", ReceiptsTable.TABLE_NAME, ReceiptsTable.COLUMN_ID];
    NSString *receiptIdAsName = [NSString stringWithFormat:@"%@_%@", ReceiptsTable.TABLE_NAME, ReceiptsTable.COLUMN_ID];
    NSString *paymentMethodIdFullName = [NSString stringWithFormat:@"%@.%@", PaymentMethodsTable.TABLE_NAME, PaymentMethodsTable.COLUMN_ID];
    NSString *paymentMethodIdAsName = [NSString stringWithFormat:@"%@_%@", PaymentMethodsTable.TABLE_NAME, PaymentMethodsTable.COLUMN_ID];
    
    DatabaseQueryBuilder *select = [DatabaseQueryBuilder selectAllStatementForTable:ReceiptsTable.TABLE_NAME];
    [select where:ReceiptsTable.COLUMN_PARENT value:trip.name];
    [select select:receiptIdFullName as:receiptIdAsName];
    [select select:paymentMethodIdFullName as:paymentMethodIdAsName];
    [select leftJoin:PaymentMethodsTable.TABLE_NAME on:ReceiptsTable.COLUMN_PAYMENT_METHOD_ID equalTo:PaymentMethodsTable.COLUMN_ID];
    [select orderBy:ReceiptsTable.COLUMN_DATE ascending:NO];
    return [self createAdapterUsingQuery:select forModel:[WBReceipt class] associatedModel:trip];
}

- (BOOL)updateReceipt:(WBReceipt *)receipt changeFileNameTo:(NSString *)fileName {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_PATH value:fileName];
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    BOOL result = [self executeQuery:update];
    if (result) {
        [receipt setImageFileName:fileName];
        [self notifyUpdateOfModel:receipt];
    }
    return result;
}

- (BOOL)copyReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [self.filesManager copyFileForReceipt:receipt toTrip:trip];

        WBTrip *original = receipt.trip;
        [receipt setTrip:trip];
        result = [self insertReceipt:receipt usingDatabase:db];
        [receipt setTrip:original];

        [self notifyInsertOfModel:receipt];
    }];
    return result;
}

- (BOOL)moveReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [self.filesManager moveFileForReceipt:receipt toTrip:trip];

        [self deleteReceipt:receipt usingDatabase:db];
        [receipt setTrip:trip];
        result = [self insertReceipt:receipt usingDatabase:db];
    }];
    return result;
}

- (BOOL)swapReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self swapReceipt:receiptOne withReceipt:receiptTwo usingDatabase:db];
    }];

    if (result) {
        [self notifySwapOfModels:@[receiptOne, receiptTwo]];
    }

    return result;
}

- (NSUInteger)nextReceiptID {
    return [self nextAutoGeneratedIDForTable:ReceiptsTable.TABLE_NAME];
}

- (BOOL)swapReceipt:(WBReceipt *)receiptOne withReceipt:(WBReceipt *)receiptTwo usingDatabase:(FMDatabase *)database {
    return [self setDateTo:receiptOne.date onReceipt:receiptTwo usingDatabase:database]
            && [self setDateTo:receiptTwo.date onReceipt:receiptOne usingDatabase:database];
}

- (BOOL)setDateTo:(NSDate *)date onReceipt:(WBReceipt *)receipt usingDatabase:(FMDatabase *)database {
    DatabaseQueryBuilder *update = [DatabaseQueryBuilder updateStatementForTable:ReceiptsTable.TABLE_NAME];
    [update addParam:ReceiptsTable.COLUMN_DATE value:date.milliseconds];
    [update where:ReceiptsTable.COLUMN_ID value:@(receipt.objectId)];
    return [self executeQuery:update usingDatabase:database];
}

- (void)appendCommonValuesFromReceipt:(WBReceipt *)receipt toQuery:(DatabaseQueryBuilder *)query {
    [query addParam:ReceiptsTable.COLUMN_PATH value:receipt.imageFileName fallback:SRNoData];
    [query addParam:ReceiptsTable.COLUMN_PARENT value:receipt.trip.name];
    [query addParam:ReceiptsTable.COLUMN_NAME value:[receipt.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [query addParam:ReceiptsTable.COLUMN_CATEGORY value:receipt.category];
    [query addParam:ReceiptsTable.COLUMN_COMMENT value:receipt.comment];
    [query addParam:ReceiptsTable.COLUMN_DATE value:receipt.date.milliseconds];
    [query addParam:ReceiptsTable.COLUMN_TIMEZONE value:receipt.timeZone.name];
    [query addParam:ReceiptsTable.COLUMN_EXPENSEABLE value:@(receipt.isExpensable)];
    [query addParam:ReceiptsTable.COLUMN_ISO4217 value:receipt.price.currency.code];
    [query addParam:ReceiptsTable.COLUMN_NOTFULLPAGEIMAGE value:@(!receipt.isFullPage)];
    [query addParam:ReceiptsTable.COLUMN_PRICE value:receipt.price.amount];
    [query addParam:ReceiptsTable.COLUMN_TAX value:receipt.tax.amount];
    [query addParam:ReceiptsTable.COLUMN_EXCHANGE_RATE value:receipt.exchangeRate];
    [query addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_1 value:[Database extraInsertValue:receipt.extraEditText1]];
    [query addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_2 value:[Database extraInsertValue:receipt.extraEditText2]];
    [query addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_3 value:[Database extraInsertValue:receipt.extraEditText3]];
    [query addParam:ReceiptsTable.COLUMN_PAYMENT_METHOD_ID value:@(receipt.paymentMethod.objectId)];
}

- (NSTimeInterval)maxSecondForReceiptsInTrip:(WBTrip *)trip onDate:(NSDate *)date {
    __block double result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [self maxSecondForReceiptsInTrip:trip onDate:date usingDatabase:db];
    }];

    return result;
}

- (NSTimeInterval)maxSecondForReceiptsInTrip:(WBTrip *)trip onDate:(NSDate *)date usingDatabase:(FMDatabase *)database {
    NSDate *beginningOfDay = [date dateAtBeginningOfDay];
    NSString *query = @"SELECT (strftime('%s', rcpt_date / 1000, 'unixepoch') - strftime('%s', :date_start, 'unixepoch')) AS seconds FROM receipts WHERE parent = :parent AND rcpt_date / 1000  >= :date_start AND rcpt_date / 1000 < :date_end ORDER BY rcpt_date DESC LIMIT 1";
    DatabaseQueryBuilder *selectSeconds = [DatabaseQueryBuilder rawQuery:query];
    [selectSeconds addParam:@"date_start" value:@(beginningOfDay.timeIntervalSince1970)];
    [selectSeconds addParam:@"date_end" value:@([beginningOfDay dateByAddingDays:1].timeIntervalSince1970)];
    [selectSeconds addParam:@"parent" value:[trip name]];
    return [self executeDoubleQuery:selectSeconds usingDatabase:database];
}

@end
