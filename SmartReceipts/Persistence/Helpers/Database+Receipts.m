//
//  Database+Receipts.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Receipts.h"
#import "DatabaseTableNames.h"
#import "Database+Functions.h"
#import "WBReceipt.h"
#import "DatabaseQueryBuilder.h"
#import "WBTrip.h"
#import "WBCurrency.h"
#import "WBPrice.h"
#import "FetchedModelAdapter.h"

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
    DatabaseQueryBuilder *insert = [DatabaseQueryBuilder insertStatementForTable:ReceiptsTable.TABLE_NAME];
    [insert addParam:ReceiptsTable.COLUMN_PATH value:receipt.imageFileName fallback:[WBReceipt NO_DATA]];
    [insert addParam:ReceiptsTable.COLUMN_PARENT value:receipt.trip.name];
    [insert addParam:ReceiptsTable.COLUMN_NAME value:[receipt.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [insert addParam:ReceiptsTable.COLUMN_CATEGORY value:receipt.category];
    [insert addParam:ReceiptsTable.COLUMN_DATE value:receipt.dateFromDateMs];
    [insert addParam:ReceiptsTable.COLUMN_TIMEZONE value:receipt.timeZone.name];
    [insert addParam:ReceiptsTable.COLUMN_EXPENSEABLE value:@(receipt.isExpensable)];
    [insert addParam:ReceiptsTable.COLUMN_ISO4217 value:receipt.price.currency.code];
    [insert addParam:ReceiptsTable.COLUMN_NOTFULLPAGEIMAGE value:@(!receipt.isFullPage)];
    [insert addParam:ReceiptsTable.COLUMN_PRICE value:receipt.price.amount];
    [insert addParam:ReceiptsTable.COLUMN_TAX value:receipt.tax.amount];
    [insert addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_1 value:[Database extraInsertValue:receipt.extraEditText1]];
    [insert addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_2 value:[Database extraInsertValue:receipt.extraEditText2]];
    [insert addParam:ReceiptsTable.COLUMN_EXTRA_EDITTEXT_3 value:[Database extraInsertValue:receipt.extraEditText3]];
    BOOL result = [self executeQuery:insert];
    return result;
}

- (NSArray *)allReceiptsForTrip:(WBTrip *)trip descending:(BOOL)desc {
    FetchedModelAdapter *adapter = [[FetchedModelAdapter alloc] initWithDatabase:self];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = :parent ORDER BY %@ %@", ReceiptsTable.TABLE_NAME, ReceiptsTable.COLUMN_PARENT, ReceiptsTable.COLUMN_DATE, (desc ? @" DESC" : @" ASC")];
    [adapter setFetchQuery:query parameters:@{@"parent": trip.name}];
    [adapter setModelClass:[WBReceipt class]];
    [adapter fetch];
    NSArray *receipts = [adapter allObjects];
    for (WBReceipt *receipt in receipts) {
        [receipt setTrip:trip];
    }
    return receipts;
}

- (NSDecimalNumber *)sumOfReceiptsForTrip:(WBTrip *)trip {
    DatabaseQueryBuilder *sumStatement = [DatabaseQueryBuilder sumStatementForTable:ReceiptsTable.TABLE_NAME];
    [sumStatement setSumColumn:ReceiptsTable.COLUMN_PRICE];
    [sumStatement where:ReceiptsTable.COLUMN_PARENT value:trip.name];
    return [self executeDecimalQuery:sumStatement];
}

+ (NSString *)extraInsertValue:(NSString *)extraValue {
    if (!extraValue) {
        return [WBReceipt NO_DATA];
    } else {
        if ([extraValue caseInsensitiveCompare:@"null"] == NSOrderedSame) {
            return @"";
        }
    }

    return extraValue;
}

@end
