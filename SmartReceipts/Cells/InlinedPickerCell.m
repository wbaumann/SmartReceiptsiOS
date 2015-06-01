//
//  InlinedPickerCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "InlinedPickerCell.h"
#import "Pickable.h"
#import "StringPickableWrapper.h"

@interface InlinedPickerCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIPickerView *picker;

@end

@implementation InlinedPickerCell

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allPickabelValues count];
}

- (void)setSelectedValue:(id<Pickable>)selectedValue {
    _selectedValue = selectedValue;

    NSUInteger index = [self.allPickabelValues indexOfObject:selectedValue];
    if (index == NSNotFound) {
        return;
    }
    [self.picker selectRow:index inComponent:0 animated:NO];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<Pickable> selected = self.allPickabelValues[row];
    return selected.presentedValue;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!self.valueChangeHandler) {
        return;
    }

    id<Pickable> selected = self.allPickabelValues[row];
    self.valueChangeHandler(selected);
}

- (void)setAllValues:(NSArray *)allValues {
    [self setAllPickabelValues:[StringPickableWrapper wrapValues:allValues]];
}

@end
