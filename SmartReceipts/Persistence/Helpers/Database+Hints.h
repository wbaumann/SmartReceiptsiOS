//
//  Database+Hints.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@interface Database (Hints)

- (NSString *)hintForTripBasedOnEntry:(NSString *)entry;
- (NSString *)hintForReceiptBasedOnEntry:(NSString *)entry;

@end
