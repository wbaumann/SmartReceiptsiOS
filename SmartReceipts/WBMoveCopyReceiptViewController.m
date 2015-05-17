//
//  WBMoveCopyReceiptViewController.m
//  SmartReceipts
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBMoveCopyReceiptViewController.h"

#import "WBDB.h"
#import "WBCustomization.h"
#import "TitleOnlyCell.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Trips.h"

@interface WBMoveCopyReceiptViewController ()

@end

@implementation WBMoveCopyReceiptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setPresentationCellNib:[TitleOnlyCell viewNib]];

    self.navigationItem.title = self.calledForCopy ? NSLocalizedString(@"Copy to", nil) : NSLocalizedString(@"Move to", nil);
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] fetchedAdapterForAllTripsExcluding:self.receipt.trip];
}


-(void)tabaleView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WBTrip* selectedTrip;// = [_trips tripAtIndex:indexPath.row];
    
    if (self.calledForCopy) {
        if ([[WBDB receipts] copyReceipt:_receipt fromTrip:self.receipt.trip toTrip:selectedTrip]) {
            //[self.tripsViewController viewController:self.receiptsViewController updatedTrip:selectedTrip];
        } else {
            NSLog(@"Copying failed");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([[WBDB receipts] moveReceipt:_receipt fromTrip:self.receipt.trip toTrip:selectedTrip]) {
            //[self.receiptsViewController notifyReceiptRemoved:_receipt];
            //[self.tripsViewController viewController:self.receiptsViewController updatedTrip:selectedTrip];
        } else {
            NSLog(@"Moving failed");
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    TitleOnlyCell *titleCell = (TitleOnlyCell *) cell;
    WBTrip *trip = object;

    [titleCell setTitle:trip.name];
}

@end
