//
//  WBNewTripViewController.h
//  SmartReceipts
//
//  Created on 17/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "WBDynamicPicker.h"

#import "HTAutocompleteTextField.h"
#import "InputCellsViewController.h"

@class WBTrip, WBNewTripViewController;

@protocol WBNewTripViewControllerDelegate <NSObject>

-(void) viewController:(WBNewTripViewController*)viewController newTrip:(WBTrip*) trip;
-(void) viewController:(WBNewTripViewController*)viewController updatedTrip:(WBTrip*) trip fromTrip:(WBTrip*) oldTrip;

@end

@interface WBNewTripViewController : InputCellsViewController

@property (weak,nonatomic) id<WBNewTripViewControllerDelegate> delegate;
@property (nonatomic, strong) WBTrip *trip;

@end
