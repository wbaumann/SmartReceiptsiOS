//
//  DatabaseTestsHelper.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class WBTrip;
@class Distance;
@class WBReceipt;

@interface DatabaseTestsHelper : Database

- (WBTrip *)createTestTrip;
- (void)insertTestDistance:(NSDictionary *)modifiedParams;
- (void)insertTestReceipt:(NSDictionary *)modifiedParams;
- (WBTrip *)insertTestTrip:(NSDictionary *)modifiedParams;
- (void)insertTestPaymentMethod:(NSString *)name;
- (WBReceipt *)receiptWithName:(NSString *)receiptName;

@end
