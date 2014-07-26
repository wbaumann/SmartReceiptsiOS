//
//  WBReceiptsDbHelper.m
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceiptsHelper.h"
#import "WBTripsHelper.h"

#import "WBPreferences.h"
#import "WBCurrency.h"

#import "WBSqlBuilder.h"

#import "WBDB.h"

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

-(BOOL) createTable {
    
    NSString* query = [@[
                         @"CREATE TABLE " ,TABLE_NAME , @" ("
                         ,COLUMN_ID , @" INTEGER PRIMARY KEY AUTOINCREMENT, "
                         ,COLUMN_PATH , @" TEXT, "
                         ,COLUMN_PARENT , @" TEXT REFERENCES " , [WBTripsHelper TABLE_NAME] , @" ON DELETE CASCADE, "
                         ,COLUMN_NAME , @" TEXT DEFAULT \"New Receipt\", "
                         ,COLUMN_CATEGORY , @" TEXT, "
                         ,COLUMN_DATE , @" DATE DEFAULT (DATE('now', 'localtime')), "
                         ,COLUMN_TIMEZONE , @" TEXT, "
                         ,COLUMN_COMMENT , @" TEXT, "
                         ,COLUMN_ISO4217 , @" TEXT NOT NULL, "
                         ,COLUMN_PRICE , @" DECIMAL(10, 2) DEFAULT 0.00, "
                         ,COLUMN_TAX , @" DECIMAL(10, 2) DEFAULT 0.00, "
                         ,COLUMN_PAYMENTMETHOD , @" TEXT, "
                         ,COLUMN_EXPENSEABLE , @" BOOLEAN DEFAULT 1, "
                         ,COLUMN_NOTFULLPAGEIMAGE , @" BOOLEAN DEFAULT 1, "
                         ,COLUMN_EXTRA_EDITTEXT_1 , @" TEXT, "
                         ,COLUMN_EXTRA_EDITTEXT_2 , @" TEXT, "
                         ,COLUMN_EXTRA_EDITTEXT_3 , @" TEXT"
                         , @");"
                         ] componentsJoinedByString:@""];
    
    __block BOOL result;
    [_databaseQueue inDatabase:^(FMDatabase* database){
        result = [database executeUpdate:query];
    }];
    return result;
}

#pragma mark - CRUD

-(NSArray*) selectAllForTrip:(WBTrip*) trip descending:(BOOL) desc {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? ORDER BY %@ %@", TABLE_NAME, COLUMN_PARENT, COLUMN_DATE, (desc ? @" DESC":@" ASC")];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [_databaseQueue inDatabase:^(FMDatabase* database){
        FMResultSet* resultSet = [database executeQuery:query, [trip name]];
        
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
        
        while ([resultSet next]) {
            
            WBReceipt *receipt =
            [[WBReceipt alloc] initWithId:[resultSet intForColumnIndex:idIndex]
                                     name:[resultSet stringForColumnIndex:nameIndex]
                                 category:[resultSet stringForColumnIndex:categoryIndex]
                            imageFileName:[resultSet stringForColumnIndex:pathIndex]
                                   dateMs:[resultSet longLongIntForColumnIndex:dateIndex]
                             timeZoneName:[resultSet stringForColumnIndex:timeZoneIndex]
                                  comment:[resultSet stringForColumnIndex:commentIndex]
                                    price:[resultSet stringForColumnIndex:priceIndex]
                                      tax:[resultSet stringForColumnIndex:taxIndex]
                             currencyCode:[resultSet stringForColumnIndex:currencyIndex]
                             isExpensable:[resultSet boolForColumnIndex:expenseableIndex]
                               isFullPage:![resultSet boolForColumnIndex:fullpageIndex]
                           extraEditText1:[resultSet stringForColumnIndex:extra_edittext_1_Index]
                           extraEditText2:[resultSet stringForColumnIndex:extra_edittext_2_Index]
                           extraEditText3:[resultSet stringForColumnIndex:extra_edittext_3_Index]];
            
            [array addObject:receipt];
        }
        
    }];
    
    // copy to make immutable
    return [array copy];
}

-(WBReceipt*) selectWithId:(int) receiptId {
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_ID];
    
    __block WBReceipt *receipt = nil;
    
    [_databaseQueue inDatabase:^(FMDatabase* database){
        FMResultSet* resultSet = [database executeQuery:query, [NSNumber numberWithInt:receiptId] ];
        
        if ([resultSet next]) {
            
            receipt =
            [[WBReceipt alloc] initWithId:[resultSet intForColumn:COLUMN_ID]
                                     name:[resultSet stringForColumn:COLUMN_NAME]
                                 category:[resultSet stringForColumn:COLUMN_CATEGORY]
                            imageFileName:[resultSet stringForColumn:COLUMN_PATH]
                                   dateMs:[resultSet longLongIntForColumn:COLUMN_DATE]
                             timeZoneName:[resultSet stringForColumn:COLUMN_TIMEZONE]
                                  comment:[resultSet stringForColumn:COLUMN_COMMENT]
                                    price:[resultSet stringForColumn:COLUMN_PRICE]
                                      tax:[resultSet stringForColumn:COLUMN_TAX]
                             currencyCode:[resultSet stringForColumn:COLUMN_ISO4217]
                             isExpensable:[resultSet boolForColumn:COLUMN_EXPENSEABLE]
                               isFullPage:![resultSet boolForColumn:COLUMN_NOTFULLPAGEIMAGE]
                           extraEditText1:[resultSet stringForColumn:COLUMN_EXTRA_EDITTEXT_1]
                           extraEditText2:[resultSet stringForColumn:COLUMN_EXTRA_EDITTEXT_2]
                           extraEditText3:[resultSet stringForColumn:COLUMN_EXTRA_EDITTEXT_3]];
            
        }
        
    }];
    
    return receipt;
}

static NSString* addExtra(WBSqlBuilder* builder, NSString* extra) {
#warning FIXME: ported from Android but misconception is visible here, null->"null"->"" when used multiple times on the same row.
    
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

-(WBReceipt*) insertReceipt:(WBReceipt*) receipt withTrip:(WBTrip*) trip {
    return [self insertWithTrip:trip
                           name:[receipt name]
                       category:[receipt category]
                  imageFileName:[receipt imageFileName]
                         dateMs:[receipt dateMs]
                   timeZoneName:[[receipt timeZone] name]
                        comment:[receipt comment]
                          price:[receipt price]
                            tax:[receipt tax]
                   currencyCode:[[receipt currency] code]
                   isExpensable:[receipt isExpensable]
                     isFullPage:[receipt isFullPage]
                 extraEditText1:[receipt extraEditText1]
                 extraEditText2:[receipt extraEditText2]
                 extraEditText3:[receipt extraEditText3]];
}

-(WBReceipt*) insertWithTrip:(WBTrip*)trip
                        name:(NSString*)name
                    category:(NSString*)category
               imageFileName:(NSString*)imageFileName
                      dateMs:(long long)dateMs
                timeZoneName:(NSString*)timeZoneName
                     comment:(NSString*)comment
                       price:(NSString*)price
                         tax:(NSString*)tax
                currencyCode:(NSString*)currencyCode
                isExpensable:(BOOL)isExpensable
                  isFullPage:(BOOL)isFullPage
              extraEditText1:(NSString*)extraEditText1
              extraEditText2:(NSString*)extraEditText2
              extraEditText3:(NSString*)extraEditText3
{
    name = [name lastPathComponent];
    imageFileName = [imageFileName lastPathComponent];
    
    WBSqlBuilder *qBuilder = [[WBSqlBuilder alloc] init];
    
    int rcptCnt = [[WBDB trips] cachedCount]; //Use this to order things more properly
    
    [qBuilder addColumn:COLUMN_PATH];
    if (!imageFileName) {
        [qBuilder addValue:[WBReceipt NO_DATA]];
    } else {
        [qBuilder addValue:imageFileName];
    }
    
    [qBuilder addColumn:COLUMN_PARENT
              andObject:[trip name]];
    
    if ([name length] > 0) {
        [qBuilder addColumn:COLUMN_NAME
                  andObject:[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    [qBuilder addColumn:COLUMN_CATEGORY
              andObject:category];
    
    
    [qBuilder addColumn:COLUMN_DATE
              andObject:[NSNumber numberWithLongLong:(dateMs + rcptCnt)]];
    
    if (!timeZoneName) {
        timeZoneName = [[NSTimeZone localTimeZone] name];
    }
    
    [qBuilder addColumn:COLUMN_TIMEZONE
              andObject:timeZoneName];
    
    [qBuilder addColumn:COLUMN_COMMENT
              andObject:comment];
    
    [qBuilder addColumn:COLUMN_EXPENSEABLE
             andBoolean:isExpensable];
    
    [qBuilder addColumn:COLUMN_ISO4217
              andObject:currencyCode];
    
    [qBuilder addColumn:COLUMN_NOTFULLPAGEIMAGE
             andBoolean:!isFullPage];
    
    if ([price length] > 0) {
        [qBuilder addColumn:COLUMN_PRICE
                  andObject:price];
    }
    
    if ([tax length] > 0) {
        [qBuilder addColumn:COLUMN_TAX
                  andObject:tax];
    }
    
    //Extras
    [qBuilder addColumn:COLUMN_EXTRA_EDITTEXT_1];
    extraEditText1 = addExtra(qBuilder, extraEditText1);
    
    [qBuilder addColumn:COLUMN_EXTRA_EDITTEXT_2];
    extraEditText2 = addExtra(qBuilder, extraEditText2);
    
    [qBuilder addColumn:COLUMN_EXTRA_EDITTEXT_3];
    extraEditText3 = addExtra(qBuilder, extraEditText3);
    
    NSString *q = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                   TABLE_NAME, [qBuilder columnsStringForInsert], [qBuilder questionMarksStringForInsert]];
    
    __block WBReceipt* receipt = nil;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        
        if(![database executeUpdate:q withArgumentsInArray:qBuilder.values]) {
            *rollback = YES;
            return;
        }
        
        // update prices in the same transaction
        NSString *newSumPrice = [[WBDB trips] sumAndUpdatePriceForTrip:trip inDatabase:database];
        if (newSumPrice == nil) {
            *rollback = YES;
            return;
        }
        [trip setPrice:newSumPrice];
        
        NSString* curr = [self selectCurrencyForReceiptsWithParent:[trip name] inDatabase:database];
        if (!curr) {
            curr = [WBTrip MULTI_CURRENCY];
        }
        [trip setCurrencyFromCode:curr];
        
        FMResultSet* cres = [database executeQuery:@"SELECT last_insert_rowid()"];
        if (!([cres next] && [cres columnCount]>0)) {
            *rollback = YES;
            return;
        }
        
        const int rid = [cres intForColumnIndex:0];
        
#warning REVIEW: why default timezone? We have timezone from argument.
        receipt =
        [[WBReceipt alloc] initWithId:rid
                                 name:name
                             category:category
                        imageFileName:imageFileName
                               dateMs:dateMs
                         timeZoneName:[[NSTimeZone localTimeZone] name]
                              comment:comment
                                price:price
                                  tax:tax
                         currencyCode:currencyCode
                         isExpensable:isExpensable
                           isFullPage:isFullPage
                       extraEditText1:extraEditText1
                       extraEditText2:extraEditText2
                       extraEditText3:extraEditText3];
        
    }];
    return receipt;
}

-(WBReceipt*) updateReceipt:(WBReceipt*)oldReceipt
                       trip:(WBTrip*)trip
                       name:(NSString*)name
                   category:(NSString*)category
                     dateMs:(long long)dateMs
                    comment:(NSString*)comment
                      price:(NSString*)price
                        tax:(NSString*)tax
               currencyCode:(NSString*)currencyCode
               isExpensable:(BOOL)isExpensable
                 isFullPage:(BOOL)isFullPage
             extraEditText1:(NSString*)extraEditText1
             extraEditText2:(NSString*)extraEditText2
             extraEditText3:(NSString*)extraEditText3 {
    
    name = [name lastPathComponent];
    
    WBSqlBuilder *qBuilder = [[WBSqlBuilder alloc] init];
    
#define qPut(column,value) [qBuilder addColumn:column andObject:value];
    
    qPut(COLUMN_NAME, [name stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    
    qPut(COLUMN_CATEGORY, category);
    
#warning REVIEW: on Android here is null what means that after building updated object on success we have timezone different than the one in DB. On iOS old timezone is set for new object if no change.
    
    NSString *timeZoneName = [[oldReceipt timeZone] name];
    if (dateMs != [oldReceipt dateMs]) {
        timeZoneName = [[NSTimeZone localTimeZone] name];
        qPut(COLUMN_TIMEZONE, timeZoneName);
    }
    
    if ((dateMs % 3600000) == 0) { // Hack to avoid identical dates (this occurs if it was set manually)
        qPut(COLUMN_DATE, [NSNumber numberWithLongLong:(dateMs + [oldReceipt receiptId])]);
    } else {
        qPut(COLUMN_DATE, [NSNumber numberWithLongLong:(dateMs)]);
    }
    
    qPut(COLUMN_COMMENT, comment);
    
    if ([price length] > 0) {
        qPut(COLUMN_PRICE, price);
    }
    
    if ([tax length] > 0) {
        qPut(COLUMN_TAX, tax);
    }
    
    qPut(COLUMN_EXPENSEABLE, (isExpensable? @1 : @0));
    qPut(COLUMN_ISO4217, currencyCode);
    qPut(COLUMN_NOTFULLPAGEIMAGE, (isFullPage? @0 : @1));
    
    //Extras
    [qBuilder addColumn:COLUMN_EXTRA_EDITTEXT_1];
    extraEditText1 = addExtra(qBuilder, extraEditText1);
    
    [qBuilder addColumn:COLUMN_EXTRA_EDITTEXT_2];
    extraEditText2 = addExtra(qBuilder, extraEditText2);
    
    [qBuilder addColumn:COLUMN_EXTRA_EDITTEXT_3];
    extraEditText3 = addExtra(qBuilder, extraEditText3);
    
#undef qPut
    
    NSString *strParams = [qBuilder columnsStringForUpdate];
    
    NSString *q = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?",
                   TABLE_NAME, strParams, COLUMN_ID];
    
    // for 'where'
    [qBuilder addValueFromInt:[oldReceipt receiptId]];
    
    __block WBReceipt* receipt = nil;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        if(![database executeUpdate:q withArgumentsInArray:qBuilder.values]) {
            *rollback = YES;
            return;
        }
        
        // update prices in the same transaction
        NSString *newSumPrice = [[WBDB trips] sumAndUpdatePriceForTrip:trip inDatabase:database];
        if (newSumPrice == nil) {
            *rollback = YES;
            return;
        }
        [trip setPrice:newSumPrice];
        
        NSString* curr = [self selectCurrencyForReceiptsWithParent:[trip name] inDatabase:database];
        if (!curr) {
            curr = [WBTrip MULTI_CURRENCY];
        }
        [trip setCurrencyFromCode:curr];
        
        receipt =
        [[WBReceipt alloc] initWithId:[oldReceipt receiptId]
                                 name:name
                             category:category
                        imageFileName:[oldReceipt imageFileName]
                               dateMs:dateMs
                         timeZoneName:timeZoneName
                              comment:comment
                                price:price
                                  tax:tax
                         currencyCode:currencyCode
                         isExpensable:isExpensable
                           isFullPage:isFullPage
                       extraEditText1:extraEditText1
                       extraEditText2:extraEditText2
                       extraEditText3:extraEditText3];
        
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
        result = [db executeUpdate:query, imageFileName, [NSNumber numberWithInt:[receipt receiptId]]];
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

#warning REVIEW: style - delete doesn't delete files related to row, but move does

-(WBReceipt*) moveReceipt:(WBReceipt*) receipt fromTrip:(WBTrip*)oldTrip toTrip:(WBTrip*) newTrip {
    WBReceipt* newReceipt = [self copyReceipt:receipt fromTrip:oldTrip toTrip:newTrip];
    if (newReceipt) {
        if ([self deleteWithId:[receipt receiptId] forTrip:oldTrip]) {
            if ([receipt hasFileForTrip:oldTrip]) {
                NSString* oldFile = [receipt imageFilePathForTrip:oldTrip];
                
#warning REVIEW: ported from Android version, it's weird that receipt is copied and returns false/nil
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

-(BOOL) deleteWithId:(int) receiptId forTrip:(WBTrip*) currentTrip {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", TABLE_NAME, COLUMN_ID];
    
    __block BOOL result;
    [_databaseQueue inTransaction:^(FMDatabase *database, BOOL *rollback){
        result = [database executeUpdate:query, [NSNumber numberWithInt:receiptId]];
        if (result) {
            NSString *newSumPrice = [[WBDB trips] sumAndUpdatePriceForTrip:currentTrip inDatabase:database];
            if (newSumPrice == nil) {
                *rollback = YES;
                result = NO;
                return;
            }
            [currentTrip setPrice:newSumPrice];
            
            NSString* curr = [self selectCurrencyForReceiptsWithParent:[currentTrip name] inDatabase:database];
            if (!curr) {
                curr = [WBTrip MULTI_CURRENCY];
            }
            [currentTrip setCurrencyFromCode:curr];
        }
    }];
    return result;
}

#warning REVIEW: it's like move up/down from Android version, anyway this method doesn't look good cos we swap dates. There should be something like one another field for ordering, or maybe I didn't get the idea and it's ok.
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
        
        NSNumber *date1 = [NSNumber numberWithLongLong:dateMs1];
        NSNumber *date2 = [NSNumber numberWithLongLong:dateMs2];
        
        if ([database executeUpdate:query, date1, [NSNumber numberWithInt:[receipt2 receiptId]] ]
            && [database executeUpdate:query, date2, [NSNumber numberWithInt:[receipt1 receiptId]]]) {
            
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

-(NSString*) selectCurrencyForReceiptsWithParent:(NSString*) parent inDatabase:(FMDatabase*) database {
    NSString* curr = nil;
    
    FMResultSet* resultSet = [database executeQuery:CURR_CNT_QUERY, parent];
    
    if (resultSet) {
        if ([resultSet next] && [resultSet columnCount] > 0) {
            int cnt = [resultSet intForColumnIndex:0];
            
            if (cnt == 1) {
                curr = [resultSet stringForColumnIndex:1];
            } else if (cnt == 0) {
                curr = [WBPreferences defaultCurrency];
            }
        }
        [resultSet close];
    }
    
    return curr;
}

-(NSString*) sumPricesForReceiptsWithParent:(NSString*) parent inDatabase:(FMDatabase*) database {
#warning REVIEW: using prices as strings is likely to cause bugs
    NSString* query = [NSString stringWithFormat:@"SELECT SUM(%@) FROM %@ WHERE %@ = ? AND %@ = 1", COLUMN_PRICE, TABLE_NAME, COLUMN_PARENT, COLUMN_EXPENSEABLE];
    
    FMResultSet* resultSet = [database executeQuery:query, parent];

    if ([resultSet next] && [resultSet columnCount] > 0) {
        double sum = [resultSet doubleForColumnIndex:0];
        [resultSet close];
        return [NSString stringWithFormat:@"%.2f",sum];
    }
    
    return nil;
}

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
        
#warning REVIEW: as on Android we ignore insert/update success, but should it be like this?
        
        if (count > 0 && overwrite) {
#warning FIXME: as on Android we update also ID of our row with id from external ID, it's going to cause bugs
            // add value for 'where id = ?'
            [values addObject:[NSNumber numberWithInt:updateID]];
            [currDB executeUpdate:updateQuery withArgumentsInArray:values];
        } else {
            [currDB executeUpdate:insertQuery withArgumentsInArray:values];
        }
        
    } while ([resultSet next]);
    
    return true;
}

#pragma mark - autocomplete

-(NSString*)hintForString:(NSString*) str {
    NSString *q = [NSString stringWithFormat:@"SELECT DISTINCT TRIM(%@) AS _id FROM %@ WHERE %@ LIKE ? ORDER BY %@", COLUMN_NAME, TABLE_NAME, COLUMN_NAME, COLUMN_NAME];
    
    NSString *like = [NSString stringWithFormat:@"%@%%", str];
    
    __block NSString *hint = nil;
    [_databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:q, like];
        if ([result next]) {
            hint = [result stringForColumn:@"_id"];
        }
    }];
    
    return hint;
}

@end
