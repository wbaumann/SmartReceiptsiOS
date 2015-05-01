//
//  WBDB.h
//  SmartReceipts
//
//  Created on 20/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBTripsHelper.h"
#import "WBReceiptsHelper.h"
#import "WBCategoriesHelper.h"
#import "WBColumnsHelper.h"
#import "Database.h"

/*
 Messages sent to table helpers are queued if they do not require passing (FMDatabase*)database as argument.
 You cannot call queued messages in the same queue because it will cause deadlock. 
 That's why secondary methods need database context, they are intented to be used in already running queue.
 
 All methods in helpers are sync.
 */

@interface WBDB : Database

+ (BOOL)open;
+ (void)close;

+ (WBTripsHelper *)trips;
+ (WBReceiptsHelper *)receipts;
+ (WBCategoriesHelper *)categories;
+ (WBColumnsHelper *)csvColumns;
+ (WBColumnsHelper *)pdfColumns;

+ (BOOL)mergeWithDatabaseAtPath:(NSString *)dbPath overwrite:(BOOL)overwrite;

@end
