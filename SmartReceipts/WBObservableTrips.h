//
//  WBTripsCollection.h
//  SmartReceipts
//
//  Created on 29/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBTrip.h"

@class WBObservableTrips;

@protocol WBObservableTripsDelegate <NSObject>

-(void) observableTrips:(WBObservableTrips*)observableTrips filledWithTrips:(NSArray*) trips;
-(void) observableTrips:(WBObservableTrips*)observableTrips addedTrip:(WBTrip*)trip atIndex:(int)index;
-(void) observableTrips:(WBObservableTrips*)observableTrips replacedTrip:(WBTrip*)oldTrip toTrip:(WBTrip*)newTrip fromIndex:(int)oldIndex toIndex:(int)newIndex;
-(void) observableTrips:(WBObservableTrips*)observableTrips removedTrip:(WBTrip*)trip atIndex:(int)index;

@end

@interface WBObservableTrips : NSObject

@property (weak,nonatomic) id<WBObservableTripsDelegate> delegate;

+(WBObservableTrips*) lastInstance;

-(NSUInteger) count;

-(void) setTrips:(NSArray*) trips;
-(void) addTrip:(WBTrip*) trip;
-(void) removeTrip:(WBTrip*) trip;
-(void) replaceTrip:(WBTrip*) oldTrip toTrip:(WBTrip*) newTrip;

-(WBTrip*) tripAtIndex:(NSUInteger)index;
-(NSUInteger) indexOfTrip:(WBTrip*) trip;

@end
