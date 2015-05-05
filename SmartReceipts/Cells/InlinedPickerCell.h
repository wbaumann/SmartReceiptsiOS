//
//  InlinedPickerCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^InlinedPickerSelectionChangeBlock)(NSString *selected);

@interface InlinedPickerCell : UITableViewCell

@property (nonatomic, copy) InlinedPickerSelectionChangeBlock valueChangeHandler;
@property (nonatomic, copy) NSString *selectedValue;
@property (nonatomic, strong) NSArray *allValues;

@end
