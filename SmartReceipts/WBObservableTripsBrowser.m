//
//  WBObservableTripsBrowser.m
//  SmartReceipts
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBObservableTripsBrowser.h"

@implementation WBObservableTripsBrowser {
    WBObservableTrips *_trips;
    NSUInteger _excludedIndex;
}

-(id)initWithTrips:(WBObservableTrips*) trips excludingIndex:(NSUInteger) excludedIndex
{
    self = [super init];
    if (self) {
        _trips = trips;
        _excludedIndex = excludedIndex;
    }
    return self;
}

-(WBTrip*)tripAtIndex:(NSUInteger)index {
    if (index >= _excludedIndex) {
        ++index;
    }
    return [_trips tripAtIndex:(int)index];
}

-(NSUInteger)count {
    const NSUInteger count = [_trips count];
    if (count > _excludedIndex) {
        return count - 1;
    }
    return count;
}

@end
