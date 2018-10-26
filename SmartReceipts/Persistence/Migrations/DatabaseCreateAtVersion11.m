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
#import "ReceiptColumn.h"
#import "LocalizedString.h"

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
    LOGGER_DEBUG(@"Insert default categories");

    // categories are localized because they are custom and red from db anyway
    NSArray *cats = @[
            LocalizedString(@"category_null", nil), LocalizedString(@"category_null_code", nil), //
            LocalizedString(@"category_airfare", nil), LocalizedString(@"category_airfare_code", nil), //
            LocalizedString(@"category_breakfast", nil), LocalizedString(@"category_breakfast_code", nil), //
            LocalizedString(@"category_dinner", nil), LocalizedString(@"category_dinner_code", nil), //
            LocalizedString(@"category_entertainment", nil), LocalizedString(@"category_entertainment_code", nil), //
            LocalizedString(@"category_gasoline", nil), LocalizedString(@"category_gasoline_code", nil), //
            LocalizedString(@"category_gift", nil), LocalizedString(@"category_gift_code", nil), //
            LocalizedString(@"category_hotel", nil), LocalizedString(@"category_hotel_code", nil), //
            LocalizedString(@"category_laundry", nil), LocalizedString(@"category_laundry_code", nil), //
            LocalizedString(@"category_lunch", nil), LocalizedString(@"category_lunch_code", nil), //
            LocalizedString(@"category_other", nil), LocalizedString(@"category_other_code", nil), //
            LocalizedString(@"category_parking_tolls", nil), LocalizedString(@"category_parking_tolls_code", nil), //
            LocalizedString(@"category_postage_shipping", nil), LocalizedString(@"category_postage_shipping_code", nil), //
            LocalizedString(@"category_car_rental", nil), LocalizedString(@"category_car_rental_code", nil), //
            LocalizedString(@"category_taxi_bus", nil), LocalizedString(@"category_taxi_bus_code", nil), //
            LocalizedString(@"category_telephone_fax", nil), LocalizedString(@"category_telephone_fax_code", nil), //
            LocalizedString(@"category_tip", nil), LocalizedString(@"category_tip_code", nil), //
            LocalizedString(@"category_train", nil), LocalizedString(@"category_train_code", nil), //
            LocalizedString(@"category_books_periodicals", nil), LocalizedString(@"category_books_periodicals_code", nil), //
            LocalizedString(@"category_cell_phone", nil), LocalizedString(@"category_cell_phone_code", nil), //
            LocalizedString(@"category_dues_subscriptions", nil), LocalizedString(@"category_dues_subscriptions_code", nil), //
            LocalizedString(@"category_meals_justified", nil), LocalizedString(@"category_meals_justified_code", nil), //
            LocalizedString(@"category_stationery_stations", nil), LocalizedString(@"category_stationery_stations_code", nil), //
            LocalizedString(@"category_training_fees", nil), LocalizedString(@"category_training_fees_code", nil), //
            LocalizedString(@"pref_distance_header", nil), LocalizedString(@"category.distance.code", nil), //
    ];

    for (NSUInteger i = 0; i < cats.count - 1; i += 2) {
        NSString *name = cats[i];
        NSString *code = cats[i + 1];
        NSString *insert = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES ('%@', '%@')",
            CategoriesTable.TABLE_NAME, CategoriesTable.COLUMN_NAME, CategoriesTable.COLUMN_CODE, name, code];
        if (![database executeUpdate:insert]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)insertDefaultReceiptColumnsIntoDatabase:(Database *)database {
    NSArray *csvColumns = @[
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_DATE", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_NAME", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_PRICE", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_CURRENCY", nil)],
            [ReceiptColumn columnName:LocalizedString(@"column_item_category_name", nil)],
            [ReceiptColumn columnName:LocalizedString(@"column_item_category_code", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_COMMENT", nil)],
            [ReceiptColumn columnName:LocalizedString(@"graphs_label_reimbursable", nil)]
    ];


    if (![database replaceAllCSVColumnsWith:csvColumns]) {
        LOGGER_WARNING(@"Error while inserting CSV columns");
        return NO;
    }

    NSArray *pdfColumns = @[
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_DATE", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_NAME", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_PRICE", nil)],
            [ReceiptColumn columnName:LocalizedString(@"RECEIPTMENU_FIELD_CURRENCY", nil)],
            [ReceiptColumn columnName:LocalizedString(@"column_item_category_name", nil)],
            [ReceiptColumn columnName:LocalizedString(@"graphs_label_reimbursable", nil)]
    ];

    return [database replaceAllPDFColumnsWith:pdfColumns];
}

@end
