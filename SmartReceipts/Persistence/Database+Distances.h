//
//  Database+Distances.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/objc.h>
#import "Database.h"

@class Distance;
@class WBTrip;

@interface Database (Distances)

- (BOOL)createDistanceTable;
- (BOOL)saveDistance:(Distance *)distance;
- (NSArray *)fetchAllDistancesForTrip:(WBTrip *)trip;

@end
