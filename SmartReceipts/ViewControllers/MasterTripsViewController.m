//
//  MasterTripsViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 16/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "MasterTripsViewController.h"

@interface MasterTripsViewController () <UISplitViewControllerDelegate>

@property (nonatomic, assign) BOOL presentDefaultTrip;

@end

@implementation MasterTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.splitViewController setDelegate:self];
    [self setPresentDefaultTrip:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self showDefaultTripInDetailView];
}

- (void)showDefaultTripInDetailView {
    if (!self.presentDefaultTrip) {
        return;
    }

    if ([self numberOfItems] > 0) {
        [self setTapped:[self objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];

        [self performSegueWithIdentifier:PresentTripDetailsSegueIdentifier sender:self];
    } else {
        [self performSegueWithIdentifier:@"NoTrip" sender:self];
    }

    [self setPresentDefaultTrip:NO];
}

- (void)contentChanged {
    [super contentChanged];
    [self showDefaultTripInDetailView];
}


- (void)didDeleteObject:(id)object atIndex:(NSUInteger)index {
    [super didDeleteObject:object atIndex:index];

    [self setPresentDefaultTrip:[object isEqual:self.lastShownTrip]];
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}

@end
