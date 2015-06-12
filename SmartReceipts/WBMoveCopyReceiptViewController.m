//
//  WBMoveCopyReceiptViewController.m
//  SmartReceipts
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBMoveCopyReceiptViewController.h"

#import "WBCustomization.h"
#import "TitleOnlyCell.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Trips.h"
#import "Database+Receipts.h"

@interface WBMoveCopyReceiptViewController ()

@end

@implementation WBMoveCopyReceiptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setPresentationCellNib:[TitleOnlyCell viewNib]];

    self.navigationItem.title = self.calledForCopy ? NSLocalizedString(@"move.copy.receipt.controller.copy.title", nil) : NSLocalizedString(@"move.copy.receipt.controller.move.title", nil);
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] fetchedAdapterForAllTripsExcluding:self.receipt.trip];
}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    WBTrip *destinationTrip = tapped;
    if (self.calledForCopy) {
        [[Database sharedInstance] copyReceipt:self.receipt toTrip:destinationTrip];
    } else {
        [[Database sharedInstance] moveReceipt:self.receipt toTrip:destinationTrip];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    TitleOnlyCell *titleCell = (TitleOnlyCell *) cell;
    WBTrip *trip = object;

    [titleCell setTitle:trip.name];
}

@end
