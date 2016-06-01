//
//  TripsViewController.m
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "TripsViewController.h"
#import "WBCellWithPriceNameDate.h"
#import "WBDateFormatter.h"
#import "WBPreferences.h"
#import "WBCustomization.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Trips.h"
#import "Constants.h"
#import "SmartReceipts-Swift.h"

NSString *const PresentTripDetailsSegueIdentifier = @"TripDetails";

@interface TripsViewController ()

@property (nonatomic, assign) CGFloat priceWidth;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *settingsButton;
@property (nonatomic, strong) WBTrip *lastShownTrip;
@property (nonatomic, copy) NSString *lastDateSeparator;

@end

@implementation TripsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setPresentationCellNib:[WBCellWithPriceNameDate viewNib]];

    _dateFormatter = [[WBDateFormatter alloc] init];

    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.editButtonItem];

    self.settingsButton.title = @"\u2699";
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:24.0], NSFontAttributeName, nil];
    [self.settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsSaved) name:SmartReceiptsSettingsSavedNotification object:nil];

    [self setLastDateSeparator:[WBPreferences dateSeparator]];
}

- (void)settingsSaved {
    if ([self.lastDateSeparator isEqualToString:[WBPreferences dateSeparator]]) {
        return;
    }

    [self setLastDateSeparator:[WBPreferences dateSeparator]];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateEditButton];
}

- (void)updateEditButton {
    self.editButtonItem.enabled = [self numberOfItems] > 0;
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] createUpdatingAdapterForAllTrips];
}

- (void)updatePricesWidth {
    CGFloat w = [self computePriceWidth];
    if (w == _priceWidth) {
        return;
    }

    _priceWidth = w;
    for (WBCellWithPriceNameDate *cell in self.tableView.visibleCells) {
        [cell.priceWidthConstraint setConstant:w];
        [cell layoutIfNeeded];
    }
}

- (CGFloat)computePriceWidth {
    CGFloat maxWidth = 0;

    for (NSUInteger i = 0; i < [self numberOfItems]; ++i) {
        WBTrip *trip = [self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *str = [trip formattedPrice];
        CGRect bounds = [str boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21]} context:nil];
        maxWidth = MAX(maxWidth, CGRectGetWidth(bounds) + 10);
    }

    return MAX(CGRectGetWidth(self.view.bounds) / 6, maxWidth);
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    WBCellWithPriceNameDate *cell = (WBCellWithPriceNameDate *) aCell;

    WBTrip *trip = object;

    cell.priceField.text = [trip formattedPrice];
    cell.nameField.text = [trip name];
    cell.dateField.text = [NSString stringWithFormat:NSLocalizedString(@"trips.controller.from.to.date.label.base", nil),
                                                     [_dateFormatter formattedDate:[trip startDate] inTimeZone:[trip startTimeZone]],
                                                     [_dateFormatter formattedDate:[trip endDate] inTimeZone:[trip endTimeZone]]];

    [cell.priceWidthConstraint setConstant:_priceWidth];
}

- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [[Database sharedInstance] deleteTrip:object];
}

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

        if (IS_IPAD) {
            vc = (WBReceiptsViewController *) [[segue destinationViewController] topViewController];
        } else {
            vc = (WBReceiptsViewController *) [segue destinationViewController];
        }

        [vc setTrip:self.tapped];
        [self setLastShownTrip:self.tapped];
    } else if ([[segue identifier] isEqualToString:@"TripCreator"]) {
        EditTripViewController *vc = (EditTripViewController *) [[segue destinationViewController] topViewController];
        [vc setTrip:self.tapped];
    }

    [self setTapped:nil];
}

- (void)contentChanged {
    [self updatePricesWidth];
    [self updateEditButton];
}

- (void)didInsertObject:(id)object atIndex:(NSUInteger)index {
    [super didInsertObject:object atIndex:index];

    [self setTapped:object];
    [self performSegueWithIdentifier:PresentTripDetailsSegueIdentifier sender:nil];
}

- (IBAction)actionAdd:(id)sender {
    self.editing = false;
    [self performSegueWithIdentifier:@"TripCreator" sender:self];
}

@end
