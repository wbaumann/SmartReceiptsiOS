//
//  Database+Trips.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 07/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"

@class WBTrip;
@class WBPrice;
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
- (WBTrip *)tripWithName:(NSString *)tripName;
- (WBPrice *)updatePriceOfTrip:(WBTrip *)trip;
- (WBPrice *)updatePriceOfTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (WBPrice *)tripPrice:(WBTrip *)trip usingDatabase:(FMDatabase *)database;
- (FetchedModelAdapter *)fetchedAdapterForAllTrips;
- (BOOL)deleteTrip:(WBTrip *)trip;
- (BOOL)deleteTrip:(WBTrip *)trip usingDatabase:(FMDatabase *)database;

@end
