//
//  Database.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "Database.h"
#import "Constants.h"
#import "WBFileManager.h"
#import "DatabaseMigration.h"
#import "ReceiptFilesManager.h"
#import "WBPreferences.h"
#import "Database+Trips.h"

NSString *const DatabaseDidInsertModelNotification = @"DatabaseDidInsertModelNotification";
NSString *const DatabaseDidDeleteModelNotification = @"DatabaseDidDeleteModelNotification";
NSString *const DatabaseDidUpdateModelNotification = @"DatabaseDidUpdateModelNotification";
NSString *const DatabaseDidSwapModelsNotification = @"DatabaseDidSwapModelsNotification";

@interface Database ()

@property (nonatomic, copy) NSString *pathToDatabase;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) ReceiptFilesManager *filesManager;
@property (nonatomic, assign) BOOL disableFilesManager;
@property (nonatomic, assign) BOOL disableNotifications;

@property (nonatomic, assign) BOOL lastKnownAddDistancePriceToReportValue;
@property (nonatomic, assign) BOOL lastKnownOnlyReportExpenseablesValue;

@end

@implementation Database

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (id)initSingleton {
    return [self initWithDatabasePath:[WBFileManager pathInDocuments:SmartReceiptsDatabaseName] tripsFolederPath:[WBFileManager tripsDirectoryPath]];
}

- (id)initWithDatabasePath:(NSString *)path tripsFolederPath:(NSString *)tripsFolderPath {
    self = [super init];
    if (self) {
        _pathToDatabase = path;
        _filesManager = [[ReceiptFilesManager alloc] initWithTripsFolder:tripsFolderPath];

        [self markKnownValues];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTripPrices) name:SmartReceiptsSettingsSavedNotification object:nil];
    }
    return self;
}

- (BOOL)open {
    return [self open:YES];
}

- (BOOL)open:(BOOL)migrateDatabase {
    FMDatabaseQueue *db = [FMDatabaseQueue databaseQueueWithPath:self.pathToDatabase];

    if (!db) {
        return NO;
    }

    [self setDatabaseQueue:db];

    if (!migrateDatabase) {
        return YES;
    }

    return [DatabaseMigration migrateDatabase:self];
}

- (void)close {
    [self.databaseQueue close];
}

- (ReceiptFilesManager *)filesManager {
    if (self.disableFilesManager) {
        return nil;
    }

    return _filesManager;
}

- (void)refreshTripPrices {
    if (![self knownPriceRelatedValuesHaveChanged]) {
        return;
    }

    [self setDisableNotifications:YES];

    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSArray *trips = [self allTripsUsingDatabase:db];
        SRLog(@"Update price on %tu trips", trips.count);
        for (WBTrip *trip in trips) {
            [self updatePriceOfTrip:trip usingDatabase:db];
        }
    }];

    [self setDisableNotifications:NO];

    [self markKnownValues];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsDatabaseBulkUpdateNotification object:nil];
    });
}

- (BOOL)knownPriceRelatedValuesHaveChanged {
    return self.lastKnownAddDistancePriceToReportValue != [WBPreferences isTheDistancePriceBeIncludedInReports]
            || self.lastKnownOnlyReportExpenseablesValue != [WBPreferences onlyIncludeExpensableReceiptsInReports];
}

- (void)markKnownValues {
    self.lastKnownAddDistancePriceToReportValue = [WBPreferences isTheDistancePriceBeIncludedInReports];
    self.lastKnownOnlyReportExpenseablesValue = [WBPreferences onlyIncludeExpensableReceiptsInReports];
}

@end
