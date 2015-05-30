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
#import "WBTripsHelper.h"
#import "WBReceiptsHelper.h"
#import "WBCategoriesHelper.h"
#import "WBColumnsHelper.h"
#import "ReceiptFilesManager.h"

NSString *const DatabaseDidInsertModelNotification = @"DatabaseDidInsertModelNotification";
NSString *const DatabaseDidDeleteModelNotification = @"DatabaseDidDeleteModelNotification";
NSString *const DatabaseDidUpdateModelNotification = @"DatabaseDidUpdateModelNotification";
NSString *const DatabaseDidSwapModelsNotification = @"DatabaseDidSwapModelsNotification";

@interface Database ()

@property (nonatomic, copy) NSString *pathToDatabase;
@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) WBTripsHelper *tripsHelper;
@property (nonatomic, strong) WBReceiptsHelper *receiptsHelper;
@property (nonatomic, strong) WBCategoriesHelper *categoriesHelper;
@property (nonatomic, strong) WBColumnsHelper *csvColumnsHelper;
@property (nonatomic, strong) WBColumnsHelper *pdfColumnsHelper;
@property (nonatomic, strong) ReceiptFilesManager *filesManager;
@property (nonatomic, assign) BOOL disableFilesManager;
@property (nonatomic, assign) BOOL disableNotifications;

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

    @synchronized ([Database class]) {
        self.tripsHelper = [[WBTripsHelper alloc] initWithDatabaseQueue:db];
        self.receiptsHelper = [[WBReceiptsHelper alloc] initWithDatabaseQueue:db];
        self.categoriesHelper = [[WBCategoriesHelper alloc] initWithDatabaseQueue:db];
        self.csvColumnsHelper = [[WBColumnsHelper alloc] initWithDatabaseQueue:db tableName:[WBColumnsHelper TABLE_NAME_CSV]];
        self.pdfColumnsHelper = [[WBColumnsHelper alloc] initWithDatabaseQueue:db tableName:[WBColumnsHelper TABLE_NAME_PDF]];
    }

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

@end
