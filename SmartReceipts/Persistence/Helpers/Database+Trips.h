//
//  Database+Trips.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 07/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class WBTrip;
@class Price;
@class FMDatabase;
@class FetchedModelAdapter;

@interface Database (Trips)

- (BOOL)createTripsTable;
- (BOOL)saveTrip:(WBTrip *)trip;
- (BOOL)updateTrip:(WBTrip *)trip;
- (NSArray *)allTrips;
- (NSArray *)allTripsUsingDatabase:(FMDatabase *)database;
- (FetchedModelAdapter *)fetchedAdapterForAllTrips;
- (FetchedModelAdapter *)fetchedAdapterForAllTripsExcluding:(WBTrip *)trip;
- (BOOL)deleteTrip:(WBTrip *)trip;
- (BOOL)deleteTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;

@end
