//
//  WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDB.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#import "WBFileManager.h"

static const int ANDROID_DATABASE_VERSION = 11;

static FMDatabaseQueue* databaseQueue = nil;

static WBTripsHelper* tripsHelper;
static WBReceiptsHelper* receiptsHelper;
static WBCategoriesHelper* categoriesHelper;
static WBColumnsHelper* csvColumnsHelper;
static WBColumnsHelper* pdfColumnsHelper;

@implementation WBDB

+(void) close {
    [databaseQueue close];
    databaseQueue = nil;
}

+(WBTripsHelper*) trips {
    return tripsHelper;
}

+(WBReceiptsHelper*) receipts {
    return receiptsHelper;
}

+(WBCategoriesHelper*) categories {
    return categoriesHelper;
}

+(WBColumnsHelper*) csvColumns {
    return csvColumnsHelper;
}

+(WBColumnsHelper*) pdfColumns {
    return pdfColumnsHelper;
}

+(BOOL) open {
    NSString *dbPath = [WBFileManager pathInDocuments:@"receipts.db"];
    
    BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    
    FMDatabaseQueue *db = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    if (!db) {
        return NO;
    }
    
    databaseQueue = db;
    
    @synchronized([WBDB class]) {
        tripsHelper = [[WBTripsHelper alloc] initWithDatabaseQueue:db];
        receiptsHelper = [[WBReceiptsHelper alloc] initWithDatabaseQueue:db];
        categoriesHelper = [[WBCategoriesHelper alloc] initWithDatabaseQueue:db];
        csvColumnsHelper = [[WBColumnsHelper alloc] initWithDatabaseQueue:db tableName:[WBColumnsHelper TABLE_NAME_CSV]];
        pdfColumnsHelper = [[WBColumnsHelper alloc] initWithDatabaseQueue:db tableName:[WBColumnsHelper TABLE_NAME_PDF]];
    }
    
    if (!existed) {
        NSLog(@"Create new database");
        
        // Android related settings in sqlite db
        if (![WBDB setupAndroidDatabaseVersionInQueue:databaseQueue]) {
            NSLog(@"Failed to set user_version");
            return NO;
        } else {
            NSLog(@"Set database version to %d", ANDROID_DATABASE_VERSION);
        }
        
        if (![WBDB setupAndroidMetadataTableInQueue:databaseQueue]) {
            NSLog(@"Failed to set up android metadata");
            return NO;
        } else {
            NSLog(@"Set up android metadata");
        }
        
        if ([WBDB createAllTables]) {
            NSLog(@"Created tables");
        } else {
            NSLog(@"Error while creating tables");
            return NO;
        }
        
        if ([WBDB insertDefaultValues]) {
            NSLog(@"Inserted default tables");
        } else {
            NSLog(@"Error while inserting default values");
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)createAllTables {
    NSLog(@"Create tables");
    return [tripsHelper createTable]
            && [receiptsHelper createTable]
            && [categoriesHelper createTable]
            && [csvColumnsHelper createTable]
            && [pdfColumnsHelper createTable];
}

+(BOOL) insertDefaultValues {
    NSLog(@"Insert default values");
    
    if (![self insertDefaultCategories]) {
        NSLog(@"Error while inserting default categories");
        return false;
    }
    
    if (![self insertDefaultColumns]) {
        NSLog(@"Error while inserting default columns");
        return false;
    }
    
    return true;
}

+(BOOL) insertDefaultCategories {
    NSLog(@"Insert default categories");
    
    // categories are localized because they are custom and red from db anyway
    NSArray* cats = @[
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
    
    for (int i=0; i<cats.count-1; i+=2) {
        if (![categoriesHelper insertWithName:[cats objectAtIndex:i] code:[cats objectAtIndex:i+1]]) {
            return false;
        }
    }
    
    return true;
}

+(BOOL) insertDefaultColumns {
    NSLog(@"Insert default CSV columns");
    
    BOOL success = [csvColumnsHelper insertWithColumnName:WBColumnNameCategoryCode]
    && [csvColumnsHelper insertWithColumnName:WBColumnNameName]
    && [csvColumnsHelper insertWithColumnName:WBColumnNamePrice]
    && [csvColumnsHelper insertWithColumnName:WBColumnNameCurrency]
    && [csvColumnsHelper insertWithColumnName:WBColumnNameDate];
    
    if (!success) {
        NSLog(@"Error while inserting CSV columns");
        return false;
    }
    
    NSLog(@"Insert default PDF columns");
    success = [pdfColumnsHelper insertWithColumnName:WBColumnNameName]
    && [pdfColumnsHelper insertWithColumnName:WBColumnNamePrice]
    && [pdfColumnsHelper insertWithColumnName:WBColumnNameDate]
    && [pdfColumnsHelper insertWithColumnName:WBColumnNameCategoryName]
    && [pdfColumnsHelper insertWithColumnName:WBColumnNameExpensable]
    && [pdfColumnsHelper insertWithColumnName:WBColumnNamePictured];
    
    if (!success) {
        NSLog(@"Error while inserting PDF columns");
        return false;
    }
    
    return true;
}

+ (BOOL)setupAndroidDatabaseVersionInQueue:(FMDatabaseQueue *)queue {
    __block BOOL result;
    [queue inDatabase:^(FMDatabase *database) {
        NSString *q = [NSString stringWithFormat:@"PRAGMA user_version = %d", ANDROID_DATABASE_VERSION];
        result = [database executeUpdate:q];
    }];
    return result;
}

+ (BOOL)setupAndroidMetadataTableInQueue:(FMDatabaseQueue *)queue {
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

+(BOOL) mergeWithDatabaseAtPath:(NSString*) dbPath overwrite:(BOOL) overwrite {
    FMDatabase *otherDb = [FMDatabase databaseWithPath:dbPath];
    if (![otherDb open]) {
        return NO;
    }
    
    __block BOOL result = false;
    
    [databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [WBDB mergeDatabase:db withDatabase:otherDb overwrite:overwrite];
        if (!result) {
            *rollback = YES;
        }
    }];
    
    return result;
}

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB overwrite:(BOOL) overwrite {
    
    if (![WBTripsHelper mergeDatabase:currDB withDatabase:importDB overwrite:overwrite]) {
        return false;
    }
    if (![WBReceiptsHelper mergeDatabase:currDB withDatabase:importDB overwrite:overwrite]) {
        return false;
    }
    if (![WBCategoriesHelper mergeDatabase:currDB withDatabase:importDB]) {
        return false;
    }
    if (![WBColumnsHelper mergeDatabase:currDB withDatabase:importDB forTable:[WBColumnsHelper TABLE_NAME_CSV]]) {
        return false;
    }
    if (![WBColumnsHelper mergeDatabase:currDB withDatabase:importDB forTable:[WBColumnsHelper TABLE_NAME_PDF]]) {
        return false;
    }
    
#warning REVIEW: should we update trip prices on end? - there is no step like this on Android
    
    NSArray *trips = [[WBDB trips] selectAllInDatabase:currDB];
    for (WBTrip* trip in trips) {
        [[WBDB trips] sumAndUpdatePriceForTrip:trip inDatabase:currDB];
    }
    
    [[WBDB categories] clearCache];
    
    return true;
}

@end
