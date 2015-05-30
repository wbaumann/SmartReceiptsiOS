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

@interface Distance (Expose)

@property (nonatomic, assign) NSUInteger objectId;

@end

@interface Database(InitExpose)

- (id)initWithDatabasePath:(NSString *)path tripsFolederPath:(NSString *)tripsFolderPath;
- (void)setDisableFilesManager:(BOOL)disable;

@end

@implementation Database (Import)

- (BOOL)importDataFromBackup:(NSString *)filePath overwrite:(BOOL)overwrite {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }

    Database *imported = [[Database alloc] initWithDatabasePath:filePath tripsFolederPath:[WBFileManager documentsPath]];
    [imported open];

    [self setDisableFilesManager:YES];

    NSArray *trips = [imported allTrips];
    for (WBTrip *trip in trips) {
        [self importTrip:trip importFrom:imported overwrite:overwrite];
    }

    [self setDisableFilesManager:NO];

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

@end
