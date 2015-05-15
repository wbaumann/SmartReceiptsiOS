//
//  EditTripViewController.h
//  SmartReceipts
//
//  Created on 17/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "WBDynamicPicker.h"

#import "HTAutocompleteTextField.h"
#import "InputCellsViewController.h"

@class WBTrip, EditTripViewController;

@protocol WBNewTripViewControllerDelegate <NSObject>

-(void) viewController:(EditTripViewController *)viewController newTrip:(WBTrip*) trip;
-(void) viewController:(EditTripViewController *)viewController updatedTrip:(WBTrip*) trip fromTrip:(WBTrip*) oldTrip;

@end

@interface EditTripViewController : InputCellsViewController

@property (weak,nonatomic) id<WBNewTripViewControllerDelegate> delegate;
@property (nonatomic, strong) WBTrip *trip;

@end
