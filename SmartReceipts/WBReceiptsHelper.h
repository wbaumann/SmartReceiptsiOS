//
//  WBReceiptsDbHelper.h
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceipt.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface WBReceiptsHelper : NSObject

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db;
- (BOOL)createTable;

-(NSArray*) selectAllForTrip:(WBTrip*) trip descending:(BOOL) desc;

-(WBReceipt*) selectWithId:(int) receiptId;

-(WBReceipt*) insertReceipt:(WBReceipt*) receipt withTrip:(WBTrip*) trip;

-(WBReceipt*) insertWithTrip:(WBTrip*)trip
                        name:(NSString*)name
                    category:(NSString*)category
               imageFileName:(NSString*)imageFileName
                      dateMs:(long long)dateMs
                timeZoneName:(NSString*)timeZoneName
                     comment:(NSString*)comment
                       price:(NSDecimalNumber*)price
                         tax:(NSDecimalNumber*)tax
                currencyCode:(NSString*)currencyCode
                isExpensable:(BOOL)isExpensable
                  isFullPage:(BOOL)isFullPage
              extraEditText1:(NSString*)extraEditText1
              extraEditText2:(NSString*)extraEditText2
              extraEditText3:(NSString*)extraEditText3;

-(WBReceipt*) updateReceipt:(WBReceipt*)oldReceipt
                       trip:(WBTrip*)trip
                       name:(NSString*)name
                   category:(NSString*)category
                     dateMs:(long long)dateMs
                    comment:(NSString*)comment
                      price:(NSDecimalNumber*)price
                        tax:(NSDecimalNumber*)tax
               currencyCode:(NSString*)currencyCode
               isExpensable:(BOOL)isExpensable
                 isFullPage:(BOOL)isFullPage
             extraEditText1:(NSString*)extraEditText1
             extraEditText2:(NSString*)extraEditText2
             extraEditText3:(NSString*)extraEditText3;

-(BOOL) updateReceipt:(WBReceipt*) receipt imageFileName:(NSString*) imageFileName;
-(WBReceipt*) copyReceipt:(WBReceipt*) receipt fromTrip:(WBTrip*)oldTrip toTrip:(WBTrip*) newTrip;
-(WBReceipt*) moveReceipt:(WBReceipt*) receipt fromTrip:(WBTrip*)oldTrip toTrip:(WBTrip*) newTrip;
-(BOOL) deleteWithParent:(NSString*) parent inDatabase:(FMDatabase*) database;
-(BOOL) deleteWithId:(int) receiptId forTrip:(WBTrip*) currentTrip;
-(BOOL) swapReceipt:(WBReceipt*) receipt1 andReceipt:(WBReceipt*) receipt2;

-(NSString*) selectCurrencyForReceiptsWithParent:(NSString*) parent inDatabase:(FMDatabase*) database;
-(NSString*) sumPricesForReceiptsWithParent:(NSString*) parent inDatabase:(FMDatabase*) database;
-(BOOL) replaceParentName:(NSString*) oldName to:(NSString*) newName inDatabase:(FMDatabase*) database;

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB overwrite:(BOOL) overwrite;

-(NSString*) hintForString:(NSString*) str;

@end
