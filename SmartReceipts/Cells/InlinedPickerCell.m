//
//  InlinedPickerCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import "InlinedPickerCell.h"

@interface InlinedPickerCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIPickerView *picker;

@end

@implementation InlinedPickerCell

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allValues count];
}

- (void)setSelectedValue:(NSString *)selectedValue {
    _selectedValue = [selectedValue mutableCopy];

    NSUInteger index = [self.allValues indexOfObject:selectedValue];
    [self.picker selectRow:index inComponent:0 animated:NO];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.allValues[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (!self.valueChangeHandler) {
        return;
    }

    NSString *selected = self.allValues[row];
    self.valueChangeHandler(selected);
}


@end
