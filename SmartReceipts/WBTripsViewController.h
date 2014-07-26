//
//  WBTripsViewController.h
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"

#import "WBNewTripViewController.h"
#import "WBReceiptsViewController.h"

#import "WBObservableTrips.h"
#import "WBObservableTripsBrowser.h"

#import "GADBannerViewDelegate.h"

@interface WBTripsViewController : WBViewController<UITableViewDataSource,UITableViewDelegate,UISplitViewControllerDelegate,WBNewTripViewControllerDelegate,WBObservableTripsDelegate,WBReceiptsViewControllerDelegate,GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (weak, nonatomic) IBOutlet UITableView *tripsTableView;

- (IBAction)actionAdd:(id)sender;

- (WBObservableTripsBrowser*) tripsBrowserExcludingTrip:(WBTrip*)trip;

@end
