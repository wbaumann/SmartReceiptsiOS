//
//  WBObservableTripsBrowser.h
//  SmartReceipts
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBObservableTrips.h"

@interface WBObservableTripsBrowser : NSObject

-(id)initWithTrips:(WBObservableTrips*) trips excludingIndex:(NSUInteger) excludedIndex;

-(WBTrip*)tripAtIndex:(NSUInteger)index;

-(NSUInteger)count;

@end
