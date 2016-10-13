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
- (FetchedModelAdapter *)fetchedAdapterForDistancesInTrip:(WBTrip *)trip ascending:(BOOL)isAscending;
- (BOOL)deleteDistance:(Distance *)distance;
- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip;
- (NSDecimalNumber *)sumOfDistancesForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (NSArray *)allDistancesForTrip:(WBTrip *)trip;
- (BOOL)deleteDistancesForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (BOOL)moveDistancesWithParent:(NSString *)previous toParent:(NSString *)next usingDatabase:(FMDatabase *)database;
- (NSDecimalNumber *)totalDistanceTraveledForTrip:(WBTrip *)trip;

@end
