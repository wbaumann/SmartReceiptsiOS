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
- (void)insertDistance:(NSDictionary *)modifiedParams;
- (void)insertReceipt:(NSDictionary *)modifiedParams;
- (WBTrip *)insertTrip:(NSDictionary *)modifiedParams;
- (void)insertPaymentMethod:(NSString *)name;
- (WBReceipt *)receiptWithName:(NSString *)receiptName;

@end
