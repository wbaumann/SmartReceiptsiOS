//
//  WBTripsViewController.h
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"

#import "EditTripViewController.h"
#import "WBReceiptsViewController.h"

#import "WBObservableTrips.h"
#import "WBObservableTripsBrowser.h"

#import "GADBannerViewDelegate.h"
#import "FetchedCollectionTableViewController.h"

@interface WBTripsViewController : FetchedCollectionTableViewController

- (WBObservableTripsBrowser *)tripsBrowserExcludingTrip:(WBTrip *)trip;

@end
