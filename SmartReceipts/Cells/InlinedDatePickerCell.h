//
//  InlinedDatePickerCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 01/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InlinedPickerCell.h"

typedef void (^InlinedDatePickerSelectionChangeBlock)(NSDate *selected);

@interface InlinedDatePickerCell : UITableViewCell

@property (nonatomic, copy) InlinedDatePickerSelectionChangeBlock changeHandler;

- (void)setDate:(NSDate *)date;
- (void)setMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;

@end
