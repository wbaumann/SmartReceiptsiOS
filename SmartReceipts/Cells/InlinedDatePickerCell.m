//
//  InlinedDatePickerCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "InlinedDatePickerCell.h"

@interface InlinedDatePickerCell ()

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@end

@implementation InlinedDatePickerCell

- (IBAction)dateChanged {
    if (!self.changeHandler) {
        return;
    }

    self.changeHandler(self.datePicker.date);
}

- (void)setDate:(NSDate *)date {
    [self.datePicker setDate:date];
}

@end
