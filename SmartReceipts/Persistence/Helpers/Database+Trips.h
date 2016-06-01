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
- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip;
- (NSDecimalNumber *)totalPriceForTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (NSArray *)allTrips;
- (NSArray *)allTripsUsingDatabase:(FMDatabase *)database;
- (Price *)updatePriceOfTrip:(WBTrip *)trip;
- (Price *)updatePriceOfTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (Price *)tripPrice:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (FetchedModelAdapter *)fetchedAdapterForAllTrips;
- (FetchedModelAdapter *)fetchedAdapterForAllTripsExcluding:(WBTrip *)trip;
- (BOOL)deleteTrip:(WBTrip *)trip;
- (BOOL)deleteTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;

@end
