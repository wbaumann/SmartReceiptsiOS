//
//  InlinedPickerCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Pickable;

typedef void (^InlinedPickerSelectionChangeBlock)(id<Pickable> selected);

@interface InlinedPickerCell : UITableViewCell

@property (nonatomic, copy) InlinedPickerSelectionChangeBlock valueChangeHandler;
@property (nonatomic, strong) id<Pickable> selectedValue;
@property (nonatomic, strong) NSArray *allPickabelValues;

- (void)setAllValues:(NSArray *)allValues;

@end
