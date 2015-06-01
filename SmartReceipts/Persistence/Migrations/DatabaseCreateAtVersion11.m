//
//  DatabaseCreateAtVersion11.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Constants.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabaseAdditions.h>
#import "DatabaseCreateAtVersion11.h"
#import "Database+Receipts.h"
#import "Database+Trips.h"
#import "Database+Categories.h"
#import "WBCategory.h"
#import "Database+CSVColumns.h"
#import "Database+PDFColumns.h"
#import "WBColumnNames.h"
#import "ReceiptColumn.h"

@implementation DatabaseCreateAtVersion11

- (NSUInteger)version {
    return 11;
}

- (BOOL)migrate:(Database *)database {
    FMDatabaseQueue *queue = database.databaseQueue;
    return [self setupAndroidMetadataTableInQueue:queue]
            && [database createTripsTable]
            && [database createReceiptsTable]
            && [database createCategoriesTable]
            && [database createCSVColumnsTable]
            && [database createPDFColumnsTable]
            && [self insertDefaultCategoriesIntoDatabase:database]
            && [self insertDefaultReceiptColumnsIntoDatabase:database];
}

- (BOOL)setupAndroidMetadataTableInQueue:(FMDatabaseQueue *)queue {
    __block BOOL result;
    [queue inDatabase:^(FMDatabase *database) {
        result = [database executeUpdate:@"CREATE TABLE android_metadata (locale TEXT)"];
        if (result) {
            // Android need at least 1 locale to not crush, let it be en_US
            result = [database executeUpdate:@"INSERT INTO \"android_metadata\" VALUES('en_US')"];
        }
    }];
    return result;
}

- (BOOL)insertDefaultCategoriesIntoDatabase:(Database *)database {
    SRLog(@"Insert default categories");

    // categories are localized because they are custom and red from db anyway
    NSArray *cats = @[
            NSLocalizedString(@"<Category>", nil), NSLocalizedString(@"NUL", nil), //
            NSLocalizedString(@"Airfare", nil), NSLocalizedString(@"AIRP", nil), //
            NSLocalizedString(@"Breakfast", nil), NSLocalizedString(@"BRFT", nil), //
            NSLocalizedString(@"Dinner", nil), NSLocalizedString(@"DINN", nil), //
            NSLocalizedString(@"Entertainment", nil), NSLocalizedString(@"ENT", nil), //
            NSLocalizedString(@"Gasoline", nil), NSLocalizedString(@"GAS", nil), //
            NSLocalizedString(@"Gift", nil), NSLocalizedString(@"GIFT", nil), //
            NSLocalizedString(@"Hotel", nil), NSLocalizedString(@"HTL", nil), //
            NSLocalizedString(@"Laundry", nil), NSLocalizedString(@"LAUN", nil), //
            NSLocalizedString(@"Lunch", nil), NSLocalizedString(@"LNCH", nil), //
            NSLocalizedString(@"Other", nil), NSLocalizedString(@"MISC", nil), //
            NSLocalizedString(@"Parking/Tolls", nil), NSLocalizedString(@"PARK", nil), //
            NSLocalizedString(@"Postage/Shipping", nil), NSLocalizedString(@"POST", nil), //
            NSLocalizedString(@"Car Rental", nil), NSLocalizedString(@"RCAR", nil), //
            NSLocalizedString(@"Taxi/Bus", nil), NSLocalizedString(@"TAXI", nil), //
            NSLocalizedString(@"Telephone/Fax", nil), NSLocalizedString(@"TELE", nil), //
            NSLocalizedString(@"Tip", nil), NSLocalizedString(@"TIP", nil), //
            NSLocalizedString(@"Train", nil), NSLocalizedString(@"TRN", nil), //
            NSLocalizedString(@"Books/Periodicals", nil), NSLocalizedString(@"ZBKP", nil), //
            NSLocalizedString(@"Cell Phone", nil), NSLocalizedString(@"ZCEL", nil), //
            NSLocalizedString(@"Dues/Subscriptions", nil), NSLocalizedString(@"ZDUE", nil), //
            NSLocalizedString(@"Meals (Justified)", nil), NSLocalizedString(@"ZMEO", nil), //
            NSLocalizedString(@"Stationery/Stations", nil), NSLocalizedString(@"ZSTS", nil), //
            NSLocalizedString(@"Training Fees", nil), NSLocalizedString(@"ZTRN", nil), //
    ];

    for (NSUInteger i = 0; i < cats.count - 1; i += 2) {
        WBCategory *category = [[WBCategory alloc] initWithName:cats[i] code:cats[i + 1]];
        if (![database saveCategory:category]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)insertDefaultReceiptColumnsIntoDatabase:(Database *)database {
    NSArray *csvColumns = @[
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameCategoryCode],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameName],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNamePrice],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameCurrency],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameDate]
    ];


    if (![database replaceAllCSVColumnsWith:csvColumns]) {
        SRLog(@"Error while inserting CSV columns");
        return NO;
    }

    NSArray *pdfColumns = @[
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameName],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNamePrice],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameDate],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameCategoryName],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNameExpensable],
            [ReceiptColumn columnWithIndex:0 name:WBColumnNamePictured]
    ];

    return [database replaceAllPDFColumnsWith:pdfColumns];
}

@end
