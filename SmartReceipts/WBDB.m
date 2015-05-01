//
//  WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDB.h"
#import "WBFileManager.h"
#import "DatabaseMigration.h"

static WBTripsHelper* tripsHelper;
static WBReceiptsHelper* receiptsHelper;
static WBCategoriesHelper* categoriesHelper;
static WBColumnsHelper* csvColumnsHelper;
static WBColumnsHelper* pdfColumnsHelper;

@implementation WBDB

+ (void)close {
    [[Database sharedInstance] close];
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

+ (BOOL)open {
    if (![[Database sharedInstance] open]) {
        return NO;
    }

    @synchronized ([WBDB class]) {
        FMDatabaseQueue *db = [[Database sharedInstance] databaseQueue];
        tripsHelper = [[WBTripsHelper alloc] initWithDatabaseQueue:db];
        receiptsHelper = [[WBReceiptsHelper alloc] initWithDatabaseQueue:db];
        categoriesHelper = [[WBCategoriesHelper alloc] initWithDatabaseQueue:db];
        csvColumnsHelper = [[WBColumnsHelper alloc] initWithDatabaseQueue:db tableName:[WBColumnsHelper TABLE_NAME_CSV]];
        pdfColumnsHelper = [[WBColumnsHelper alloc] initWithDatabaseQueue:db tableName:[WBColumnsHelper TABLE_NAME_PDF]];
    }

    return YES;
}

+ (BOOL)insertDefaultColumnsIntoQueue:(FMDatabaseQueue *)queue {
    NSLog(@"Insert default CSV columns");

    BOOL success = [csvColumnsHelper insertWithColumnName:WBColumnNameCategoryCode intoQueue:queue]
            && [csvColumnsHelper insertWithColumnName:WBColumnNameName intoQueue:queue]
            && [csvColumnsHelper insertWithColumnName:WBColumnNamePrice intoQueue:queue]
            && [csvColumnsHelper insertWithColumnName:WBColumnNameCurrency intoQueue:queue]
            && [csvColumnsHelper insertWithColumnName:WBColumnNameDate intoQueue:queue];

    if (!success) {
        NSLog(@"Error while inserting CSV columns");
        return false;
    }

    NSLog(@"Insert default PDF columns");
    success = [pdfColumnsHelper insertWithColumnName:WBColumnNameName intoQueue:queue]
            && [pdfColumnsHelper insertWithColumnName:WBColumnNamePrice intoQueue:queue]
            && [pdfColumnsHelper insertWithColumnName:WBColumnNameDate intoQueue:queue]
            && [pdfColumnsHelper insertWithColumnName:WBColumnNameCategoryName intoQueue:queue]
            && [pdfColumnsHelper insertWithColumnName:WBColumnNameExpensable intoQueue:queue]
            && [pdfColumnsHelper insertWithColumnName:WBColumnNamePictured intoQueue:queue];

    if (!success) {
        NSLog(@"Error while inserting PDF columns");
        return false;
    }

    return true;
}

+ (BOOL)mergeWithDatabaseAtPath:(NSString *)dbPath overwrite:(BOOL)overwrite {
    FMDatabase *otherDb = [FMDatabase databaseWithPath:dbPath];
    if (![otherDb open]) {
        return NO;
    }

    __block BOOL result = false;

    [[[Database sharedInstance] databaseQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
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
    
    
    NSArray *trips = [[WBDB trips] selectAllInDatabase:currDB];
    for (WBTrip* trip in trips) {
        [[WBDB trips] sumAndUpdatePriceForTrip:trip inDatabase:currDB];
    }
    
    [[WBDB categories] clearCache];
    
    return true;
}

@end
