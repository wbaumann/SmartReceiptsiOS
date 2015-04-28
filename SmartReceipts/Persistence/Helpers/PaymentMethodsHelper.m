//
//  PaymentMethodsHelper.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 28/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <FMDB/FMDatabaseQueue.h>
#import "PaymentMethodsHelper.h"
#import "FMDatabaseAdditions.h"
#import "Database.h"
#import "FMDatabaseQueue+QueueShortcuts.h"
#import "SmartReceipts-Swift.h"

@implementation PaymentMethodsHelper

+ (BOOL)createTableInQueue:(FMDatabaseQueue *)queue {
    NSArray *sql = @[@"CREATE TABLE ", PaymentMethodsTable.TABLE_NAME, @" (", PaymentMethodsTable.COLUMN_ID, @" INTEGER PRIMARY KEY AUTOINCREMENT, ", PaymentMethodsTable.COLUMN_METHOD, @" TEXT", @");"];
    //TODO jaanus: insert defaults
    return [queue executeUpdateWithStatementComponents:sql];
}

@end
