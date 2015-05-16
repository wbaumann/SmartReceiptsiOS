//
//  WBTripsViewController.m
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTripsViewController.h"

#import "WBCellWithPriceNameDate.h"

#import "WBDB.h"

#import "WBDateFormatter.h"

#import "WBFileManager.h"

#import "HUD.h"

#import "WBBackupHelper.h"

#import "WBAppDelegate.h"

#import "WBPreferences.h"

#import "GADMasterViewController.h"

#import "GADBannerView.h"
#import "WBCustomization.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Trips.h"

static NSString *CellIdentifier = @"Cell";

@interface WBTripsViewController () <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate, WBNewTripViewControllerDelegate, WBObservableTripsDelegate, WBReceiptsViewControllerDelegate, GADBannerViewDelegate> {
    WBDateFormatter *_dateFormatter;

    WBTrip *_lastShownTrip;

    CGFloat _priceWidth;

    NSString *_lastDateSeparator;

    //Height 0 constraint
    __weak IBOutlet NSLayoutConstraint *adConstraint;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *settingsButton;
@property (nonatomic, strong) WBTrip *tapped;

@end

@implementation WBTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setPresentationCellNib:[WBCellWithPriceNameDate viewNib]];

    _dateFormatter = [[WBDateFormatter alloc] init];


    //TODO jaanus
    //if ([WBBackupHelper isDataBlocked] == false) {
    //    [HUD showUIBlockingIndicatorWithText:@""];
    //    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
    //        NSArray *trips = [[WBDB trips] selectAll];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [_trips setTrips:trips];
    //            [HUD hideUIBlockingIndicator];
    //        });
    //    });
    //}

    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.editButtonItem];

    if (self.splitViewController) {
        self.splitViewController.delegate = self;
    }

    {
        self.settingsButton.title = @"\u2699";
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:24.0], NSFontAttributeName, nil];
        [self.settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    }

    GADMasterViewController *sharedAdController = [GADMasterViewController sharedInstance];
    [sharedAdController resetAdView:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateEditButton];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if (adConstraint) {
        bannerView.frame = CGRectMake(0.0,
                self.view.frame.size.height -
                        bannerView.frame.size.height,
                bannerView.frame.size.width,
                bannerView.frame.size.height);
        [self.view addSubview:bannerView];
        adConstraint.constant = 50.0f;
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    if (adConstraint) {
        adConstraint.constant = 0.0f;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (_lastDateSeparator && ![[WBPreferences dateSeparator] isEqualToString:_lastDateSeparator]) {
        [self.tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _lastDateSeparator = [WBPreferences dateSeparator];
}

- (void)updateEditButton {
    self.editButtonItem.enabled = [self numberOfItems] > 0;
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] fetchedAdapterForAllTrips];
}


- (void)updatePricesWidth {
    CGFloat w = [self computePriceWidth];
    if (w == _priceWidth) {
        return;
    }

    [self.tableView beginUpdates];
    _priceWidth = w;
    for (WBCellWithPriceNameDate *cell in self.tableView.visibleCells) {
        [cell.priceWidthConstraint setConstant:w];
        [cell layoutIfNeeded];
    }
    [self.tableView endUpdates];
}

- (CGFloat)computePriceWidth {
    CGFloat maxWidth = 0;

    for (NSUInteger i = 0; i < [self numberOfItems]; ++i) {
        NSString *str = [[self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] priceWithCurrencyFormatted];
        CGRect bounds = [str boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21]} context:nil];
        maxWidth = MAX(maxWidth, CGRectGetWidth(bounds) + 10);
    }

    return MAX(CGRectGetWidth(self.view.bounds) / 6, maxWidth);
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    WBCellWithPriceNameDate *cell = (WBCellWithPriceNameDate *) aCell;

    WBTrip *trip = object;

    cell.priceField.text = [trip priceWithCurrencyFormatted];
    cell.nameField.text = [trip name];
    cell.dateField.text = [NSString stringWithFormat:NSLocalizedString(@"%@ to %@", nil),
                                                     [_dateFormatter formattedDate:[trip startDate] inTimeZone:[trip startTimeZone]],
                                                     [_dateFormatter formattedDate:[trip endDate] inTimeZone:[trip endTimeZone]]];

    [cell.priceWidthConstraint setConstant:_priceWidth];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        WBTrip* trip = [_trips tripAtIndex:(int)indexPath.row];
//        if([[WBDB trips] deleteWithName:[trip name]]){
//            [_trips removeTrip:trip];
//            [WBFileManager deleteIfExists:[trip directoryPath]];
//        }
//    }
//}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    [self setTapped:tapped];
    if (self.editing) {
        [self performSegueWithIdentifier:@"TripCreator" sender:self];
    } else {
        [self performSegueWithIdentifier:@"TripDetails" sender:self];
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"TripDetails"]) {
        WBReceiptsViewController *vc;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            vc = (WBReceiptsViewController *) [[segue destinationViewController] topViewController];
        } else {
            vc = (WBReceiptsViewController *) [segue destinationViewController];
        }

        vc.delegate = self;
        vc.tripsViewController = self;

        vc.trip = self.tapped;
        _lastShownTrip = vc.trip;
        [self setTapped:nil];
    }
    else if ([[segue identifier] isEqualToString:@"TripCreator"]) {
        EditTripViewController *vc = (EditTripViewController *) [[segue destinationViewController] topViewController];

        vc.delegate = self;

        [vc setTrip:self.tapped];

    }
}

- (void)contentChanged {
    [self updatePricesWidth];
    [self updateEditButton];
}

/*
#pragma mark - WBNewTripViewControllerDelegate

-(void)viewController:(EditTripViewController *)viewController newTrip:(WBTrip *)trip{
    [_trips addTrip:trip];
}

-(void)viewController:(EditTripViewController *)viewController updatedTrip:(WBTrip *)trip fromTrip:(WBTrip *)oldTrip{
    [_trips replaceTrip:oldTrip toTrip:trip];
}

#pragma mark - WBReceiptsViewControllerDelegate

-(void)viewController:(WBReceiptsViewController *)viewController updatedTrip:(WBTrip *)trip{
    NSUInteger idx = [_trips indexOfTrip:trip];
    if (idx == NSNotFound) {
        return;
    }

    WBCellWithPriceNameDate* cell = (WBCellWithPriceNameDate*)[self.tripsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];

    cell.priceField.text = [trip priceWithCurrencyFormatted];

    [self updatePricesWidth];
}

#pragma mark - WBObservableTripsDelegate

-(void) showDefaultTripInDetailView {
    if ([_trips count] > 0) {
        [self.tripsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

        [self performSegueWithIdentifier: @"TripDetails" sender: self];

    } else {
        NSIndexPath *ip = [self.tripsTableView indexPathForSelectedRow];
        if (ip) {
            [self.tripsTableView deselectRowAtIndexPath:ip animated:YES];
        }

        [self performSegueWithIdentifier: @"NoTrip" sender: self];
    }
}

-(void) observableTrips:(WBObservableTrips*)observableTrips filledWithTrips:(NSArray*) trips {
    [self.tripsTableView reloadData];

    [self updatePricesWidth];

    [self updateEditButton];

    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        [self showDefaultTripInDetailView];
    }
}

-(void) observableTrips:(WBObservableTrips*)observableTrips addedTrip:(WBTrip*)trip atIndex:(int)index {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tripsTableView beginUpdates];
    [self.tripsTableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tripsTableView endUpdates];

    [self updatePricesWidth];

    [self updateEditButton];

    [self.tripsTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self performSegueWithIdentifier: @"TripDetails" sender: self];
}

-(void)observableTrips:(WBObservableTrips *)observableTrips replacedTrip:(WBTrip *)oldTrip toTrip:(WBTrip *)newTrip fromIndex:(int)oldIndex toIndex:(int)newIndex {
    
    [self.tripsTableView beginUpdates];
    
    if (oldIndex == newIndex) {
        [self.tripsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tripsTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tripsTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tripsTableView endUpdates];
    
    [self updatePricesWidth];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        // show new trip on iPad
        [self.tripsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:newIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self performSegueWithIdentifier: @"TripDetails" sender: self];
    }
}

-(void) observableTrips:(WBObservableTrips*)observableTrips removedTrip:(WBTrip*)trip atIndex:(int)index {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tripsTableView beginUpdates];
    [self.tripsTableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
    [self.tripsTableView endUpdates];
    
    [self updatePricesWidth];
    
    [self updateEditButton];
    
    if ((trip == _lastShownTrip) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ){
        // show default trip on iPad if we removed selected
        [self showDefaultTripInDetailView];
    }
} */

- (WBObservableTripsBrowser *)tripsBrowserExcludingTrip:(WBTrip *)trip {
    return nil;//[[WBObservableTripsBrowser alloc] initWithTrips:_trips excludingIndex:[_trips indexOfTrip:trip]];
}

- (IBAction)actionAdd:(id)sender {
    self.editing = false;
    [self performSegueWithIdentifier:@"TripCreator" sender:self];
}
@end
