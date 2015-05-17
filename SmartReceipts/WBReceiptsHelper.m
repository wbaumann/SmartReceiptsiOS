//
//  WBReceiptsDbHelper.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceiptsHelper.h"
#import "WBTripsHelper.h"

#import "WBCurrency.h"

#import "WBSqlBuilder.h"

#import "WBDB.h"
#import "WBPrice.h"
#import "Database+Receipts.h"
#import "Database+Trips.h"
#import "PaymentMethod.h"

static NSString * const TABLE_NAME = @"receipts";
static NSString * const COLUMN_ID = @"id";
static NSString * const COLUMN_PATH = @"path";
static NSString * const COLUMN_NAME = @"name";
static NSString * const COLUMN_PARENT = @"parent";
static NSString * const COLUMN_CATEGORY = @"category";
static NSString * const COLUMN_PRICE = @"price";
static NSString * const COLUMN_TAX = @"tax";
static NSString * const COLUMN_PAYMENTMETHOD = @"paymentmethod";
static NSString * const COLUMN_DATE = @"rcpt_date";
static NSString * const COLUMN_TIMEZONE = @"timezone";
static NSString * const COLUMN_COMMENT = @"comment";
static NSString * const COLUMN_EXPENSEABLE = @"expenseable";
static NSString * const COLUMN_ISO4217 = @"isocode";
static NSString * const COLUMN_NOTFULLPAGEIMAGE = @"fullpageimage";
static NSString * const COLUMN_EXTRA_EDITTEXT_1 = @"extra_edittext_1";
static NSString * const COLUMN_EXTRA_EDITTEXT_2 = @"extra_edittext_2";
static NSString * const COLUMN_EXTRA_EDITTEXT_3 = @"extra_edittext_3";

@implementation WBReceiptsHelper
{
    FMDatabaseQueue* _databaseQueue;
    
    NSString* CURR_CNT_QUERY;
}

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db
{
    self = [super init];
    if (self) {
        self->_databaseQueue = db;
        CURR_CNT_QUERY = [NSString stringWithFormat:@"SELECT COUNT(*), %@ FROM (SELECT COUNT(*), %@ FROM %@ WHERE %@ = ? GROUP BY %@ );", COLUMN_ISO4217, COLUMN_ISO4217, TABLE_NAME, COLUMN_PARENT, COLUMN_ISO4217];
    }
    return self;
}

#pragma mark - CRUD
static NSString* addExtra(WBSqlBuilder* builder, NSString* extra) {
    
    if (extra == nil) {
        [builder addValue:[WBReceipt NO_DATA]];
    } else {
        if ([extra caseInsensitiveCompare:@"null"] == NSOrderedSame) {
            extra = @"";
        }
        [builder addValue:extra];
    }
    return extra; // to update original value if changed
}

- (WBReceipt *)insertReceipt:(WBReceipt *)receipt withTrip:(WBTrip *)trip {
    return [self insertWithTrip:trip name:[receipt name] category:[receipt category] imageFileName:[receipt imageFileName] dateMs:[receipt dateMs] timeZoneName:[[receipt timeZone] name] comment:[receipt comment] price:[receipt price] tax:[receipt tax] isExpensable:[receipt isExpensable] isFullPage:[receipt isFullPage] extraEditText1:[receipt extraEditText1] extraEditText2:[receipt extraEditText2] extraEditText3:[receipt extraEditText3] paymentMethod:nil];
}

- (WBReceipt *)insertWithTrip:(WBTrip *)trip name:(NSString *)name category:(NSString *)category imageFileName:(NSString *)imageFileName dateMs:(long long)dateMs timeZoneName:(NSString *)timeZoneName comment:(NSString *)comment price:(WBPrice *)price tax:(WBPrice *)tax isExpensable:(BOOL)isExpensable isFullPage:(BOOL)isFullPage extraEditText1:(NSString *)extraEditText1 extraEditText2:(NSString *)extraEditText2 extraEditText3:(NSString *)extraEditText3 paymentMethod:(PaymentMethod *)paymentMethod {
    name = [name lastPathComponent];
    imageFileName = [imageFileName lastPathComponent];

    WBReceipt *receipt = [[WBReceipt alloc] initWithId:NSNotFound
                                                  name:name
                                              category:category
                                         imageFileName:imageFileName
                                                dateMs:dateMs
                                          timeZoneName:[[NSTimeZone localTimeZone] name]
                                               comment:comment
                                                 price:price
                                                   tax:tax
                                          isExpensable:isExpensable
                                            isFullPage:isFullPage
                                        extraEditText1:extraEditText1
                                        extraEditText2:extraEditText2
                                        extraEditText3:extraEditText3];
    [receipt setTrip:trip];
    [receipt setPaymentMethod:paymentMethod];


    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        BOOL result = [[Database sharedInstance] saveReceipt:receipt usingDatabase:database];
        if (!result) {
            *rollback = YES;
            return;
        }

        // update prices in the same transaction
        WBPrice *totalPrice = [[Database sharedInstance] updatePriceOfTrip:trip usingDatabase:database];
        if (!totalPrice) {
            *rollback = YES;
            return;
        }
        [trip setPrice:totalPrice];

        FMResultSet* cres = [database executeQuery:@"SELECT last_insert_rowid()"];
        if (!([cres next] && [cres columnCount]>0)) {
            *rollback = YES;
            return;
        }
        
        NSUInteger rid = (NSUInteger) [cres intForColumnIndex:0];
        [receipt setObjectId:rid];
    }];
    return receipt;
}

-(BOOL) updateReceipt:(WBReceipt*) receipt imageFileName:(NSString*) imageFileName {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", TABLE_NAME, COLUMN_PATH, COLUMN_ID];
    
    imageFileName = [imageFileName lastPathComponent];
    
    if (imageFileName == nil) {
        imageFileName = [WBReceipt NO_DATA];
    }
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:query, imageFileName, @([receipt receiptId])];
    }];
    return result;
}

-(WBReceipt*) copyReceipt:(WBReceipt*) receipt fromTrip:(WBTrip*)oldTrip toTrip:(WBTrip*) newTrip {
    NSString* newFile = nil;
    if ([receipt hasFileForTrip:oldTrip]) {
        NSLog(@"copyReceipt -> hasFile");
        
        NSString* oldFile = [receipt imageFilePathForTrip:oldTrip];
        newFile = [receipt imageFilePathForTrip:newTrip];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFile]) {
            [[NSFileManager defaultManager] removeItemAtPath:newFile error:nil];
        }
        
        [newTrip createDirectoryIfNotExists];
        if(![[NSFileManager defaultManager] copyItemAtPath:oldFile toPath:newFile error:nil]){
            NSLog(@"Failed to copy file");
            newFile = nil;
            return nil;
        }
    }
    
    WBReceipt* newReceipt = [self insertReceipt:receipt withTrip:newTrip];
    if (newReceipt) {
        return newReceipt;
    } else {
        if (newFile) {
            [[NSFileManager defaultManager] removeItemAtPath:newFile error:nil];
        }
        return nil;
    }
}


-(WBReceipt*) moveReceipt:(WBReceipt*) receipt fromTrip:(WBTrip*)oldTrip toTrip:(WBTrip*) newTrip {
    WBReceipt* newReceipt = [self copyReceipt:receipt fromTrip:oldTrip toTrip:newTrip];
    if (newReceipt) {
        if ([self deleteWithId:[receipt receiptId] forTrip:oldTrip]) {
            if ([receipt hasFileForTrip:oldTrip]) {
                NSString* oldFile = [receipt imageFilePathForTrip:oldTrip];
                
                if ([[NSFileManager defaultManager] removeItemAtPath:oldFile error:nil]) {
                    return newReceipt;
                } else {
                    return nil;
                }
            } else {
                return newReceipt;
            }
        } else {
            // undo copy
            // we don't care about result because it failed anyway
            [self deleteWithId:[newReceipt receiptId] forTrip:newTrip];
            [[NSFileManager defaultManager] removeItemAtPath:[newReceipt imageFilePathForTrip:newTrip] error:nil];
            return nil;
        }
    }
    return nil;
}

-(BOOL) deleteWithParent:(NSString*) parent inDatabase:(FMDatabase*) database {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_PARENT];
    return [database executeUpdate:query, parent];
}

-(BOOL) deleteWithId:(NSUInteger) receiptId forTrip:(WBTrip*) currentTrip {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_ID];
    
    __block BOOL result;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        result = [database executeUpdate:query, @(receiptId)];
        if (result) {
            WBPrice *totalPrice = [[Database sharedInstance] updatePriceOfTrip:currentTrip usingDatabase:database];
            [currentTrip setPrice:totalPrice];
        }
    }];
    return result;
}


-(BOOL) swapReceipt:(WBReceipt*) receipt1 andReceipt:(WBReceipt*) receipt2 {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", TABLE_NAME, COLUMN_DATE, COLUMN_ID];
    
    __block BOOL result = NO;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback) {
        long long dateMs1 = [receipt1 dateMs];
        long long dateMs2 = [receipt2 dateMs];
        
        if (dateMs1 == dateMs2) {
            if ([receipt1 receiptId] > [receipt2 receiptId]) {
                dateMs1++;
            } else {
                dateMs2++;
            }
        }
        
        NSNumber *date1 = @(dateMs1);
        NSNumber *date2 = @(dateMs2);
        
        if ([database executeUpdate:query, date1, @([receipt2 receiptId]) ]
            && [database executeUpdate:query, date2, @([receipt1 receiptId])]) {
            
            [receipt1 setDateMs:dateMs2];
            [receipt2 setDateMs:dateMs1];
            
            result = YES;
        } else {
            *rollback = YES;
        }
    }];
    return result;
}

#pragma mark - for another tables

-(BOOL) replaceParentName:(NSString*) oldName to:(NSString*) newName inDatabase:(FMDatabase*) database {
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", TABLE_NAME, COLUMN_PARENT, COLUMN_PARENT];
    return [database executeUpdate:query,newName,oldName];
}

#pragma mark - merge

// NSArray doesn't accept nils so we have to check them
static inline NSObject* checkNil(NSObject* obj) {
    return (obj?obj:[NSNull null]);
}

static inline id getString(FMResultSet* resultSet, int index) {
    return checkNil([resultSet stringForColumnIndex:index]);
}

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB overwrite:(BOOL) overwrite {
    NSLog(@"Merging receipts");
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM %@", TABLE_NAME];
    
    FMResultSet* resultSet = [importDB executeQuery:selectQuery];
    
    if (![resultSet next]) {
        return false;
    }
    
    const int idIndex = [resultSet columnIndexForName:COLUMN_ID];
    const int pathIndex = [resultSet columnIndexForName:COLUMN_PATH];
    const int nameIndex = [resultSet columnIndexForName:COLUMN_NAME];
    const int categoryIndex = [resultSet columnIndexForName:COLUMN_CATEGORY];
    const int priceIndex = [resultSet columnIndexForName:COLUMN_PRICE];
    const int taxIndex = [resultSet columnIndexForName:COLUMN_TAX];
    const int dateIndex = [resultSet columnIndexForName:COLUMN_DATE];
    const int timeZoneIndex = [resultSet columnIndexForName:COLUMN_TIMEZONE];
    const int commentIndex = [resultSet columnIndexForName:COLUMN_COMMENT];
    const int expenseableIndex = [resultSet columnIndexForName:COLUMN_EXPENSEABLE];
    const int currencyIndex = [resultSet columnIndexForName:COLUMN_ISO4217];
    const int fullpageIndex = [resultSet columnIndexForName:COLUMN_NOTFULLPAGEIMAGE];
    const int extra_edittext_1_Index = [resultSet columnIndexForName:COLUMN_EXTRA_EDITTEXT_1];
    const int extra_edittext_2_Index = [resultSet columnIndexForName:COLUMN_EXTRA_EDITTEXT_2];
    const int extra_edittext_3_Index = [resultSet columnIndexForName:COLUMN_EXTRA_EDITTEXT_3];
    
    const int parentIndex = [resultSet columnIndexForName:COLUMN_PARENT];
    const int paymentMethodIndex = [resultSet columnIndexForName:COLUMN_PAYMENTMETHOD];
    
    const BOOL hasTimezones = timeZoneIndex > 0;
    
    NSMutableArray *columns =
    @[
      COLUMN_ID,
      COLUMN_PATH,
      COLUMN_NAME,
      COLUMN_PARENT,
      COLUMN_CATEGORY,
      COLUMN_PRICE,
      COLUMN_DATE,
      COLUMN_COMMENT,
      COLUMN_EXPENSEABLE,
      COLUMN_ISO4217,
      COLUMN_NOTFULLPAGEIMAGE,
      COLUMN_EXTRA_EDITTEXT_1,
      COLUMN_EXTRA_EDITTEXT_2,
      COLUMN_EXTRA_EDITTEXT_3,
      COLUMN_TAX,
      ].mutableCopy;
    
    if (hasTimezones) {
        [columns addObject:COLUMN_TIMEZONE];
    }
    [columns addObject:COLUMN_PAYMENTMETHOD];
    
    NSString *insertQuery = [NSString stringWithFormat:@"%@ INTO %@ (%@) VALUES (%@)",
                             (overwrite ? @"INSERT OR REPLACE" : @"INSERT OR IGNORE"),
                             TABLE_NAME,
                             [WBSqlBuilder columnsStringForInsertWithColumns:columns],
                             [WBSqlBuilder questionMarksStringForInsertWithColumns:columns]
                             ];
    
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?",
                             TABLE_NAME, [WBSqlBuilder columnsStringForUpdateWithColumns:columns], COLUMN_ID];
    
    NSString *countQuery = [NSString stringWithFormat:@"SELECT COUNT(*), %@ FROM %@ WHERE %@ = ? AND %@ = ? AND %@ = ?",
                            COLUMN_ID,
                            TABLE_NAME,
                            COLUMN_PATH, COLUMN_NAME, COLUMN_DATE];
    
    do {
        NSString* name = [resultSet stringForColumnIndex:nameIndex];
        NSNumber* date = [NSNumber numberWithLongLong:[resultSet longLongIntForColumnIndex:dateIndex]];
        
        // Backwards compatibility stuff
        // no package name here so we just get directory name
        NSString* path = [[resultSet stringForColumnIndex:pathIndex] lastPathComponent];
        NSString* parent = [[resultSet stringForColumnIndex:parentIndex] lastPathComponent];
        
        FMResultSet* countResult = [currDB executeQuery:countQuery,path,name,date];
        
        if (![countResult next]) {
            [countResult close];
            continue;
        }
        
        int count = [countResult intForColumnIndex:0];
        int updateID = [countResult intForColumnIndex:1];
        [countResult close];
        
        NSMutableArray *values =
        [@[
           [NSNumber numberWithInt:[resultSet intForColumnIndex:idIndex]],
           checkNil(path),
           checkNil(name),
           checkNil(parent),
           getString(resultSet, categoryIndex),
           getString(resultSet, priceIndex),
           date,
           getString(resultSet, commentIndex),
           [NSNumber numberWithInt:[resultSet intForColumnIndex:expenseableIndex]],
           getString(resultSet, currencyIndex),
           [NSNumber numberWithInt:[resultSet intForColumnIndex:fullpageIndex]],
           getString(resultSet, extra_edittext_1_Index),
           getString(resultSet, extra_edittext_2_Index),
           getString(resultSet, extra_edittext_3_Index),
           getString(resultSet, taxIndex),
           ] mutableCopy];
        
        if (hasTimezones) {
            [values addObject:getString(resultSet, timeZoneIndex)];
        }
        
        [values addObject:getString(resultSet, paymentMethodIndex)];
        
        
        if (count > 0 && overwrite) {
            // add value for 'where id = ?'
            [values addObject:[NSNumber numberWithInt:updateID]];
            [currDB executeUpdate:updateQuery withArgumentsInArray:values];
        } else {
            [currDB executeUpdate:insertQuery withArgumentsInArray:values];
        }
        
    } while ([resultSet next]);
    
    return true;
}

@end
