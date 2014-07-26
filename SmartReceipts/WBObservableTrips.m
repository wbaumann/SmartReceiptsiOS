//
//  WBTripsCollection.m
//  SmartReceipts
//
//  Created on 29/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBObservableTrips.h"

WBObservableTrips *_lastInstance;

@implementation WBObservableTrips
{
    NSMutableArray *array;
}

+(WBObservableTrips*) lastInstance {
    return _lastInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _lastInstance = self;
        array = [NSMutableArray array];
    }
    return self;
}

-(NSUInteger) count {
    return [array count];
}

-(void) setTrips:(NSArray*) trips {
    array = [trips mutableCopy];
    [self.delegate observableTrips:self filledWithTrips:array];
}

-(void) addTrip:(WBTrip*) trip {
    int pos = [self findIndexForEndDate:[trip endDate]];
    [array insertObject:trip atIndex:pos];
    [self.delegate observableTrips:self addedTrip:trip atIndex:pos];
}

-(void) removeTrip:(WBTrip*) trip {
    int pos = (int)[array indexOfObject:trip];
    [array removeObjectAtIndex:pos];
    [self.delegate observableTrips:self removedTrip:trip atIndex:pos];
}

-(void) replaceTrip:(WBTrip*) oldTrip toTrip:(WBTrip*) newTrip {
    int oldPos = (int)[array indexOfObject:oldTrip];
    [array removeObjectAtIndex:oldPos];
    
    int newPos = [self findIndexForEndDate:[newTrip endDate]];
    [array insertObject:newTrip atIndex:newPos];
    
    [self.delegate observableTrips:self replacedTrip:oldTrip toTrip:newTrip fromIndex:oldPos toIndex:newPos];
}

-(WBTrip*) tripAtIndex:(int)index {
    return [array objectAtIndex:index];
}

-(NSUInteger) indexOfTrip:(WBTrip*) trip {
    return [array indexOfObject:trip];
}

-(int) findIndexForEndDate:(NSDate*) endDate {
    const int count = (int)[array count];
    int i = 0;
    for (; i<count; ++i) {
        NSDate *oed = [[self tripAtIndex:i] endDate];
        if ([endDate compare:oed] != NSOrderedAscending) {
            return i;
        }
    }
    return i;
}

@end
