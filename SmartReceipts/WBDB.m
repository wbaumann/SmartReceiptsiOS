//
//  WBDB.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDB.h"
#import "Database+Trips.h"

@interface Database (Expose)

@property (nonatomic, strong) WBTripsHelper *tripsHelper;
@property (nonatomic, strong) WBReceiptsHelper *receiptsHelper;
@property (nonatomic, strong) WBCategoriesHelper *categoriesHelper;
@property (nonatomic, strong) WBColumnsHelper *csvColumnsHelper;
@property (nonatomic, strong) WBColumnsHelper *pdfColumnsHelper;

@end

@implementation WBDB

+ (void)close {
    [[Database sharedInstance] close];
}

+ (WBTripsHelper *)trips {
    return [[Database sharedInstance] tripsHelper];
}

+ (WBReceiptsHelper *)receipts {
    return [[Database sharedInstance] receiptsHelper];
}

+ (WBCategoriesHelper *)categories {
    return [[Database sharedInstance] categoriesHelper];
}

+ (WBColumnsHelper *)csvColumns {
    return [[Database sharedInstance] csvColumnsHelper];
}

+ (WBColumnsHelper *)pdfColumns {
    return [[Database sharedInstance] pdfColumnsHelper];
}

+ (BOOL)open {
    return [[Database sharedInstance] open];
}

+ (BOOL)insertDefaultColumnsIntoQueue:(FMDatabaseQueue *)queue {
    NSLog(@"Insert default CSV columns");

    WBColumnsHelper *csvColumns = [Database sharedInstance].csvColumnsHelper;
    BOOL success = [csvColumns insertWithColumnName:WBColumnNameCategoryCode intoQueue:queue]
            && [csvColumns insertWithColumnName:WBColumnNameName intoQueue:queue]
            && [csvColumns insertWithColumnName:WBColumnNamePrice intoQueue:queue]
            && [csvColumns insertWithColumnName:WBColumnNameCurrency intoQueue:queue]
            && [csvColumns insertWithColumnName:WBColumnNameDate intoQueue:queue];

    if (!success) {
        NSLog(@"Error while inserting CSV columns");
        return false;
    }

    NSLog(@"Insert default PDF columns");
    WBColumnsHelper *pdfColumns = [Database sharedInstance].pdfColumnsHelper;
    success = [pdfColumns insertWithColumnName:WBColumnNameName intoQueue:queue]
            && [pdfColumns insertWithColumnName:WBColumnNamePrice intoQueue:queue]
            && [pdfColumns insertWithColumnName:WBColumnNameDate intoQueue:queue]
            && [pdfColumns insertWithColumnName:WBColumnNameCategoryName intoQueue:queue]
            && [pdfColumns insertWithColumnName:WBColumnNameExpensable intoQueue:queue]
            && [pdfColumns insertWithColumnName:WBColumnNamePictured intoQueue:queue];

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
    for (WBTrip *trip in trips) {
        [[Database sharedInstance] updatePriceOfTrip:trip];
    }
    
    [[WBDB categories] clearCache];
    
    return true;
}

@end
