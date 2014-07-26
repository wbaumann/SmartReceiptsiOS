//
//  WBNewTripViewController.m
//  SmartReceipts
//
//  Created on 17/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBNewTripViewController.h"
#import "WBDateFormatter.h"
#import "WBTrip.h"

#import "WBDB.h"
#import "WBPreferences.h"

#import "WBTextUtils.h"

#import "WBAutocompleteHelper.h"

static const int TAG_START = 1, TAG_END = 2;

@interface WBNewTripViewController ()
{
    WBDynamicPicker* _dynamicDatePicker;
    WBTrip* _trip;
    WBDateFormatter* _dateFormatter;
    
    NSDate *_startDate, *_endDate;
    NSTimeZone *_startTimeZone, *_endTimeZone;
    
    WBAutocompleteHelper *_autocompleteHelper;
}
@end

@implementation WBNewTripViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _dateFormatter = [[WBDateFormatter alloc] init];
    
    _dynamicDatePicker =[[WBDynamicPicker alloc] initWithType:WBDynamicPickerTypeDate withController:self];
    _dynamicDatePicker.delegate = self;
    
    _autocompleteHelper = [[WBAutocompleteHelper alloc] initWithAutocompleteField:self.nameTextField inView:self.view useReceiptsHints:NO];
    
    self.labelName.text = NSLocalizedString(@"Name", nil);
    self.labelStartDate.text = NSLocalizedString(@"Start Date", nil);
    self.labelEndDate.text = NSLocalizedString(@"End Date", nil);
    
    self.nameTextField.delegate = self;
    
    // to disable autocorrection, it may be irritating cos force it on auto-unfocus
    // self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self.nameTextField becomeFirstResponder];
    
    if (_trip) {
        self.navigationItem.title = NSLocalizedString(@"Edit Trip", nil);
        self.nameTextField.text = [_trip name];
        _startDate = [_trip startDate];
        _endDate = [_trip endDate];
        _startTimeZone = [_trip startTimeZone];
        _endTimeZone = [_trip endTimeZone];
    } else {
        self.navigationItem.title = NSLocalizedString(@"New Trip", nil);
        _startDate = [NSDate date];
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = [WBPreferences defaultTripDuration];
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        _endDate = [theCalendar dateByAddingComponents:dayComponent toDate:_startDate options:0];
        
        _startTimeZone = _endTimeZone = [NSTimeZone localTimeZone];
    }
    
    [self.startDateButton setTitle:[_dateFormatter formattedDate:_startDate inTimeZone:_startTimeZone] forState:UIControlStateNormal];
    [self.endDateButton setTitle:[_dateFormatter formattedDate:_endDate inTimeZone:_endTimeZone] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unfocusTextField:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;

}

// unfocus textfield on touch out
- (void)unfocusTextField:(UITapGestureRecognizer*) recognizer {
    [self.view endEditing:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [_autocompleteHelper textFieldDidBeginEditing:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_autocompleteHelper textFieldDidEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [WBTextUtils isProperName:newText];
}

- (void)setTrip:(WBTrip*) trip
{
    _trip = trip;
}

-(void)dynamicPicker:(WBDynamicPicker *)dynamicPicker doneWith:(id)subject
{
    if (dynamicPicker.tag == TAG_START) {
        _startDate = [dynamicPicker selectedDate];
        [self.startDateButton setTitle:[_dateFormatter formattedDate:_startDate inTimeZone:_startTimeZone] forState:UIControlStateNormal];
    } else {
        _endDate = [dynamicPicker selectedDate];
        [self.endDateButton setTitle:[_dateFormatter formattedDate:_endDate inTimeZone:_endTimeZone] forState:UIControlStateNormal];
    }
}

- (IBAction)actionDone:(id)sender {
    WBTrip* newTrip;
    
    NSString* name = [self.nameTextField.text lastPathComponent];
    
    if ([name length]<=0) {
        [WBNewTripViewController showAlertWithTitle:nil message:NSLocalizedString(@"Please enter a name",nil)];
        return;
    }
    
    if (_trip == nil) {
        newTrip = [[WBDB trips] insertWithName:name from:_startDate to:_endDate];
        if(!newTrip){
            [WBNewTripViewController showAlertWithTitle:nil message:NSLocalizedString(@"Cannot add this trip",nil)];
            return;
        }
        [self.delegate viewController:self newTrip:newTrip];
    } else {
        newTrip = [[WBDB trips] updateTrip:_trip dir:name from:_startDate to:_endDate];
        if(!newTrip){
            [WBNewTripViewController showAlertWithTitle:nil message:NSLocalizedString(@"Cannot save this trip",nil)];
            return;
        }
        [self.delegate viewController:self updatedTrip:newTrip fromTrip:_trip];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startDateButtonClicked:(id)sender {
    [_dynamicDatePicker setTag:TAG_START];
    [_dynamicDatePicker setDate:_startDate];
    [_dynamicDatePicker showFromView:self.startDateButton];
}

- (IBAction)endDateButtonClicked:(id)sender {
    [_dynamicDatePicker setTag:TAG_END];
    [_dynamicDatePicker setDate:_endDate];
    [_dynamicDatePicker showFromView:self.endDateButton];
}

+ (void)showAlertWithTitle:(NSString*) title message:(NSString*) message {
    [[[UIAlertView alloc]
      initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
}

@end
