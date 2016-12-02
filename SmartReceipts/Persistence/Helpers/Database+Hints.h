//
//  Database+Hints.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 11/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@interface Database (Hints)

/// Returns NSArray of NSString
- (NSArray *)hintForTripBasedOnEntry:(NSString *)entry;
- (NSArray *)hintForReceiptBasedOnEntry:(NSString *)entry;

@end
