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
            NSLocalizedString(@"category.none.name", nil), NSLocalizedString(@"category.none.code", nil), //
            NSLocalizedString(@"category.airfare.name", nil), NSLocalizedString(@"category.airfare.code", nil), //
            NSLocalizedString(@"category.breakfast.name", nil), NSLocalizedString(@"category.breakfast.code", nil), //
            NSLocalizedString(@"category.dinner.name", nil), NSLocalizedString(@"category.dinner.code", nil), //
            NSLocalizedString(@"category.entertainment.name", nil), NSLocalizedString(@"category.entertainment.code", nil), //
            NSLocalizedString(@"category.gasoline.name", nil), NSLocalizedString(@"category.gasoline.code", nil), //
            NSLocalizedString(@"category.gift.name", nil), NSLocalizedString(@"category.gift.code", nil), //
            NSLocalizedString(@"category.hotel.name", nil), NSLocalizedString(@"category.hotel.code", nil), //
            NSLocalizedString(@"category.laundry.name", nil), NSLocalizedString(@"category.laundry.code", nil), //
            NSLocalizedString(@"category.lunch.name", nil), NSLocalizedString(@"category.lunch.code", nil), //
            NSLocalizedString(@"category.other.name", nil), NSLocalizedString(@"category.other.code", nil), //
            NSLocalizedString(@"category.parking.tolls.name", nil), NSLocalizedString(@"category.parking.tolls.code", nil), //
            NSLocalizedString(@"category.postage.shipping.name", nil), NSLocalizedString(@"category.postage.shipping.code", nil), //
            NSLocalizedString(@"category.car.rental.name", nil), NSLocalizedString(@"category.car.rental.code", nil), //
            NSLocalizedString(@"category.taxi.bus.name", nil), NSLocalizedString(@"category.taxi.bus.code", nil), //
            NSLocalizedString(@"category.telephone.fax.name", nil), NSLocalizedString(@"category.telephone.fax.code", nil), //
            NSLocalizedString(@"category.tip.name", nil), NSLocalizedString(@"category.tip.code", nil), //
            NSLocalizedString(@"category.train.name", nil), NSLocalizedString(@"category.train.code", nil), //
            NSLocalizedString(@"category.books.periodicals.name", nil), NSLocalizedString(@"category.books.periodicals.code", nil), //
            NSLocalizedString(@"categiry.cell.phone.name", nil), NSLocalizedString(@"categiry.cell.phone.code", nil), //
            NSLocalizedString(@"category.dues.subscriptions.name", nil), NSLocalizedString(@"category.dues.subscriptions.code", nil), //
            NSLocalizedString(@"category.meals.justified.name", nil), NSLocalizedString(@"category.meals.justified.code", nil), //
            NSLocalizedString(@"category.stationery.stations.name", nil), NSLocalizedString(@"category.stationery.stations.code", nil), //
            NSLocalizedString(@"category.training.fees.name", nil), NSLocalizedString(@"category.training.fees.code", nil), //
            NSLocalizedString(@"category.distance.name", nil), NSLocalizedString(@"category.distance.code", nil), //
    ];

    for (NSUInteger i = 0; i < cats.count - 1; i += 2) {
        WBCategory *category = [[WBCategory alloc] initWithName:cats[i] code:cats[i + 1]];
        category.customOrderId = i/2;
        if (![database saveCategory:category]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)insertDefaultReceiptColumnsIntoDatabase:(Database *)database {
    NSInteger csvIndex = [database nextCustomOrderIdForCSVColumn];
    NSArray *csvColumns = @[
            [ReceiptColumn columnWithIndex:csvIndex name:NSLocalizedString(@"receipt.column.date", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 1 name:NSLocalizedString(@"receipt.column.name", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 2 name:NSLocalizedString(@"receipt.column.price", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 3 name:NSLocalizedString(@"receipt.column.currency", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 4 name:NSLocalizedString(@"receipt.column.category.name", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 5 name:NSLocalizedString(@"receipt.column.category.code", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 6 name:NSLocalizedString(@"receipt.column.comment", nil)],
            [ReceiptColumn columnWithIndex:csvIndex + 7 name:NSLocalizedString(@"receipt.column.reimbursable", nil)]
    ];


    if (![database replaceAllCSVColumnsWith:csvColumns]) {
        LOGGER_WARNING(@"Error while inserting CSV columns");
        return NO;
    }

    NSInteger pdfIndex = [database nextCustomOrderIdForCSVColumn];
    NSArray *pdfColumns = @[
            [ReceiptColumn columnWithIndex:pdfIndex name:NSLocalizedString(@"receipt.column.date", nil)],
            [ReceiptColumn columnWithIndex:pdfIndex + 1 name:NSLocalizedString(@"receipt.column.name", nil)],
            [ReceiptColumn columnWithIndex:pdfIndex + 2 name:NSLocalizedString(@"receipt.column.price", nil)],
            [ReceiptColumn columnWithIndex:pdfIndex + 3 name:NSLocalizedString(@"receipt.column.currency", nil)],
            [ReceiptColumn columnWithIndex:pdfIndex + 4 name:NSLocalizedString(@"receipt.column.category.name", nil)],
            [ReceiptColumn columnWithIndex:pdfIndex + 5 name:NSLocalizedString(@"receipt.column.reimbursable", nil)]
    ];

    return [database replaceAllPDFColumnsWith:pdfColumns];
}

@end
