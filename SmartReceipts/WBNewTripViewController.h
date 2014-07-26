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

@class WBTrip, WBNewTripViewController;

@protocol WBNewTripViewControllerDelegate <NSObject>

-(void) viewController:(WBNewTripViewController*)viewController newTrip:(WBTrip*) trip;
-(void) viewController:(WBNewTripViewController*)viewController updatedTrip:(WBTrip*) trip fromTrip:(WBTrip*) oldTrip;

@end

@interface WBNewTripViewController : WBTableViewController<UITableViewDataSource,WBDynamicPickerDelegate,UITextFieldDelegate>

@property (weak,nonatomic) id<WBNewTripViewControllerDelegate> delegate;

- (void)setTrip:(WBTrip*) trip;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionCancel:(id)sender;

@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelStartDate;
@property (weak, nonatomic) IBOutlet UILabel *labelEndDate;

- (IBAction)startDateButtonClicked:(id)sender;
- (IBAction)endDateButtonClicked:(id)sender;
@end
