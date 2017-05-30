//
//  WBAutoPicker.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDynamicPicker.h"

#import "WBPopoverPicker.h"
#import "WBActionSheetPicker.h"

@interface WBDynamicPicker ()
{
    WBAbstractPicker *abstractPicker;
}
@end

@implementation WBDynamicPicker

- (id)initWithType:(WBDynamicPickerType)type withController:(UIViewController*) vc
{
    self = [super init];
    if (self) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            abstractPicker = [[WBPopoverPicker alloc] initAsDatePicker:(type==WBDynamicPickerTypeDate) withController:vc];
        } else {
            abstractPicker = [[WBActionSheetPicker alloc] initAsDatePicker:(type==WBDynamicPickerTypeDate) withController:vc];
        }
        
        abstractPicker.pickerView.dataSource = self;
        abstractPicker.pickerView.delegate = self;
        abstractPicker.delegate = self;
    }
    return self;
}

- (void)setTitle:(NSString*)title
{
    [abstractPicker setTitle:title];
}

- (void)showFromView:(UIView*) view
{
    [abstractPicker showPickerFromView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem*) barButtonItem
{
    [abstractPicker showPickerFromBarButtonItem:barButtonItem];
}

- (void)setSelectedRow:(NSInteger) row
{
    [abstractPicker.pickerView selectRow:row inComponent:0 animated:NO];
}

- (void)setDate:(NSDate*) date
{
    [abstractPicker.datePicker setDate:date];
}

- (NSInteger) selectedRow
{
    return [abstractPicker.pickerView selectedRowInComponent:0];
}

- (NSDate*) selectedDate
{
    return abstractPicker.datePicker.date;
}

#pragma mark - pickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.delegate dynamicPickerNumberOfRows:self];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.delegate dynamicPicker:self titleForRow:row];
}

#pragma mark - popover

-(void)abstractPickerCancel:(WBPopoverPicker *)picker
{
}

-(void)abstractPickerDone:(WBPopoverPicker *)picker
{
    if ([self.delegate respondsToSelector:@selector(dynamicPicker:doneWith:)]) {
        [self.delegate dynamicPicker:self doneWith:abstractPicker.pickerView];
    }
}

@end
