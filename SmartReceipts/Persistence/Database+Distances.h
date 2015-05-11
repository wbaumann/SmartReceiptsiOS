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
@class FetchedModelAdapter;

@interface Database (Distances)

- (BOOL)createDistanceTable;
- (BOOL)saveDistance:(Distance *)distance;
- (FetchedModelAdapter *)fetchedAdapterForDistancesInTrip:(WBTrip *)trip;
- (BOOL)deleteDistance:(Distance *)distance;
- (BOOL)updateDistance:(Distance *)distance;
- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip;
- (NSString *)currencyForTripDistances:(WBTrip *)trip;

@end
