//
//  TripsViewController.h
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"

#import "EditTripViewController.h"
#import "WBReceiptsViewController.h"

#import "WBObservableTrips.h"

#import "FetchedCollectionTableViewController.h"

extern NSString *const PresentTripDetailsSegueIdentifier;

@interface TripsViewController : FetchedCollectionTableViewController

@property (nonatomic, strong) WBTrip *tapped;
@property (nonatomic, strong, readonly) WBTrip *lastShownTrip;

@end
