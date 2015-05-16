//
//  WBMoveCopyReceiptViewController.m
//  SmartReceipts
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBMoveCopyReceiptViewController.h"

#import "WBDB.h"

@interface WBMoveCopyReceiptViewController ()

@property (weak) WBReceiptsViewController* receiptsViewController;
@property (weak) WBTripsViewController* tripsViewController;

@end

//TODO jaanus: fix this controller
@implementation WBMoveCopyReceiptViewController
{
    WBObservableTripsBrowser * _trips;
    WBTrip * _trip;
    WBReceipt * _receipt;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.calledForCopy
    ? NSLocalizedString(@"Copy to",nil)
    : NSLocalizedString(@"Move to",nil);
    
    // go up in hierarchy for our data
    self.receiptsViewController = self.receiptActionsViewController.receiptsViewController;
    self.tripsViewController = self.receiptsViewController.tripsViewController;
    
    _trip = self.receiptsViewController.trip;
    _receipt = self.receiptActionsViewController.receipt;
    
    _trips = [self.tripsViewController tripsBrowserExcludingTrip:_trip];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WBTrip* selectedTrip = [_trips tripAtIndex:indexPath.row];
    
    if (self.calledForCopy) {
        if ([[WBDB receipts] copyReceipt:_receipt fromTrip:_trip toTrip:selectedTrip]) {
            //[self.tripsViewController viewController:self.receiptsViewController updatedTrip:selectedTrip];
        } else {
            NSLog(@"Copying failed");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([[WBDB receipts] moveReceipt:_receipt fromTrip:_trip toTrip:selectedTrip]) {
            [self.receiptsViewController notifyReceiptRemoved:_receipt];
            //[self.tripsViewController viewController:self.receiptsViewController updatedTrip:selectedTrip];
        } else {
            NSLog(@"Moving failed");
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_trips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[_trips tripAtIndex:indexPath.row] name];
    
    return cell;
}

@end
