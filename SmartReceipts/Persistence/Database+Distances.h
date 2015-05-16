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
@class FMDatabase;

@interface Database (Distances)

- (BOOL)createDistanceTable;
- (BOOL)saveDistance:(Distance *)distance;
- (BOOL)saveDistance:(Distance *)distance usingDatabase:(FMDatabase *)database;
- (FetchedModelAdapter *)fetchedAdapterForDistancesInTrip:(WBTrip *)trip;
- (BOOL)deleteDistance:(Distance *)distance;
- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip;
- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (NSString *)currencyForTripDistances:(WBTrip *)trip;
- (NSString *)currencyForTripDistances:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (NSArray *)allDistancesForTrip:(WBTrip *)trip;

@end
