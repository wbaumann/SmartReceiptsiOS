//
//  Database+Import.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database+Import.h"
#import "WBFileManager.h"
#import "Database+Trips.h"
#import "WBTrip.h"
#import "Database+Receipts.h"
#import "WBReceipt.h"
#import "Database+Distances.h"
#import "Distance.h"
#import "Constants.h"
#import "Database+PaymentMethods.h"
#import "PaymentMethod.h"
#import "Database+Categories.h"
#import "WBCategory.h"
#import "Database+PDFColumns.h"
#import "Database+CSVColumns.h"

@interface Distance (Expose)

@property (nonatomic, assign) NSUInteger objectId;

@end

@interface Database(InitExpose)

- (id)initWithDatabasePath:(NSString *)path tripsFolederPath:(NSString *)tripsFolderPath;
- (void)setDisableFilesManager:(BOOL)disable;

@property (nonatomic, assign) BOOL disableNotifications;

@end

@implementation Database (Import)

- (BOOL)importDataFromBackup:(NSString *)filePath overwrite:(BOOL)overwrite {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }

    Database *imported = [[Database alloc] initWithDatabasePath:filePath tripsFolederPath:[WBFileManager documentsPath]];
    [imported open];

    [self setDisableFilesManager:YES];
    [self setDisableNotifications:YES];

    [self importCategoriesFrom:imported overwrite:overwrite];
    
    // Note: these 3 always overwrite to avoid data inconsistencies
    [self importCSVColumnsFrom:imported];
    [self importPDFColumnsFrom:imported];
    [self importPaymentMethodsFrom:imported];
    
    NSArray *trips = [imported allTrips];
    for (WBTrip *trip in trips) {
        [self importTrip:trip importFrom:imported overwrite:overwrite];
    }

    [self setDisableFilesManager:NO];
    [self setDisableNotifications:NO];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsDatabaseBulkUpdateNotification object:nil];
    });

    return YES;
}

- (void)importTrip:(WBTrip *)trip importFrom:(Database *)importFrom overwrite:(BOOL)overwrite {
    WBTrip *existing = [self tripWithName:trip.name];
    if (existing && !overwrite) {
        return;
    }

    if (existing) {
        [self deleteTrip:existing];
    }

    [self saveTrip:trip];

    NSArray *receipts = [importFrom allReceiptsForTrip:trip];
    for (WBReceipt *receipt in receipts) {
        [receipt setObjectId:0];
        [self saveReceipt:receipt];
    }

    NSArray *distances = [importFrom allDistancesForTrip:trip];
    for (Distance *distance in distances) {
        [distance setObjectId:0];
        [self saveDistance:distance];
    }
}

- (void)importPDFColumnsFrom:(Database *)database {
    NSArray *columns = [database allPDFColumns];
    [self replaceAllPDFColumnsWith:columns];
}

- (void)importCSVColumnsFrom:(Database *)database {
    NSArray *columns = [database allCSVColumns];
    [self replaceAllCSVColumnsWith:columns];
}

- (void)importPaymentMethodsFrom:(Database *)database {
    // We have to delete all existing ones to avoid "keying" issues due to auto-increment ids
    NSArray *existing = [self allPaymentMethods];
    for (PaymentMethod *existingMethod in existing) {
        [self deletePaymentMethod:existingMethod];
    }
    
    NSArray *imported = [database allPaymentMethods];
    for (PaymentMethod *method in imported) {
        [self savePaymentMethod:method];
    }
}

- (void)importCategoriesFrom:(Database *)database overwrite:(BOOL)overwrite {
    // Since we don't have a foreign table for categories, we can handle overwrites here
    NSArray *existing = [self listAllCategories];
    if (overwrite) {
        for (WBCategory *existingCategory in existing) {
            [self deleteCategory:existingCategory];
        }
        
        existing = @[];
    }
    
    NSArray *imported = [database listAllCategories];
    for (WBCategory *category in imported) {
        if ([existing containsObject:category]) {
            continue;
        }

        [self saveCategory:category];
    }
}

@end
