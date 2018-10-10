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
            NSLocalizedString(@"category_null", nil), NSLocalizedString(@"category_null_code", nil), //
            NSLocalizedString(@"category_airfare", nil), NSLocalizedString(@"category_airfare_code", nil), //
            NSLocalizedString(@"category_breakfast", nil), NSLocalizedString(@"category_breakfast_code", nil), //
            NSLocalizedString(@"category_dinner", nil), NSLocalizedString(@"category_dinner_code", nil), //
            NSLocalizedString(@"category_entertainment", nil), NSLocalizedString(@"category_entertainment_code", nil), //
            NSLocalizedString(@"category_gasoline", nil), NSLocalizedString(@"category_gasoline_code", nil), //
            NSLocalizedString(@"category_gift", nil), NSLocalizedString(@"category_gift_code", nil), //
            NSLocalizedString(@"category_hotel", nil), NSLocalizedString(@"category_hotel_code", nil), //
            NSLocalizedString(@"category_laundry", nil), NSLocalizedString(@"category_laundry_code", nil), //
            NSLocalizedString(@"category_lunch", nil), NSLocalizedString(@"category_lunch_code", nil), //
            NSLocalizedString(@"category_other", nil), NSLocalizedString(@"category_other_code", nil), //
            NSLocalizedString(@"category_parking_tolls", nil), NSLocalizedString(@"category_parking_tolls_code", nil), //
            NSLocalizedString(@"category_postage_shipping", nil), NSLocalizedString(@"category_postage_shipping_code", nil), //
            NSLocalizedString(@"category_car_rental", nil), NSLocalizedString(@"category_car_rental_code", nil), //
            NSLocalizedString(@"category_taxi_bus", nil), NSLocalizedString(@"category_taxi_bus_code", nil), //
            NSLocalizedString(@"category_telephone_fax", nil), NSLocalizedString(@"category_telephone_fax_code", nil), //
            NSLocalizedString(@"category_tip", nil), NSLocalizedString(@"category_tip_code", nil), //
            NSLocalizedString(@"category_train", nil), NSLocalizedString(@"category_train_code", nil), //
            NSLocalizedString(@"category_books_periodicals", nil), NSLocalizedString(@"category_books_periodicals_code", nil), //
            NSLocalizedString(@"category_cell_phone", nil), NSLocalizedString(@"category_cell_phone_code", nil), //
            NSLocalizedString(@"category_dues_subscriptions", nil), NSLocalizedString(@"category_dues_subscriptions_code", nil), //
            NSLocalizedString(@"category_meals_justified", nil), NSLocalizedString(@"category_meals_justified_code", nil), //
            NSLocalizedString(@"category_stationery_stations", nil), NSLocalizedString(@"category_stationery_stations_code", nil), //
            NSLocalizedString(@"category_training_fees", nil), NSLocalizedString(@"category_training_fees_code", nil), //
            NSLocalizedString(@"pref_distance_header", nil), NSLocalizedString(@"category.distance.code", nil), //
    ];

    for (NSUInteger i = 0; i < cats.count - 1; i += 2) {
        WBCategory *category = [[WBCategory alloc] initWithName:cats[i] code:cats[i + 1]];
        category.customOrderId = -1;
        if (![database saveCategory:category]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)insertDefaultReceiptColumnsIntoDatabase:(Database *)database {
    NSArray *csvColumns = @[
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_DATE", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_NAME", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_PRICE", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_CURRENCY", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"column_item_category_name", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"column_item_category_code", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_COMMENT", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"graphs_label_reimbursable", nil)]
    ];


    if (![database replaceAllCSVColumnsWith:csvColumns]) {
        LOGGER_WARNING(@"Error while inserting CSV columns");
        return NO;
    }

    NSArray *pdfColumns = @[
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_DATE", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_NAME", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_PRICE", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"RECEIPTMENU_FIELD_CURRENCY", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"column_item_category_name", nil)],
            [ReceiptColumn columnName:NSLocalizedString(@"graphs_label_reimbursable", nil)]
    ];

    return [database replaceAllPDFColumnsWith:pdfColumns];
}

@end
