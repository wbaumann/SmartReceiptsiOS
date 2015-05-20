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

@class WBPrice;
@class WBTrip;
@class PaymentMethod;

@interface WBReceiptsHelper : NSObject

- (id)initWithDatabaseQueue:(FMDatabaseQueue*) db;

-(BOOL) swapReceipt:(WBReceipt*) receipt1 andReceipt:(WBReceipt*) receipt2;

+(BOOL) mergeDatabase:(FMDatabase*) currDB withDatabase:(FMDatabase*) importDB overwrite:(BOOL) overwrite;

@end
