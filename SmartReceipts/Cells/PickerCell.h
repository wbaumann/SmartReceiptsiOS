//
//  PickerCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryCell.h"
#import "TitledTextEntryCell.h"

@protocol Pickable;

@interface PickerCell : UITableViewCell

@property (nonatomic, strong) id<Pickable> pickableValue;

- (void)setTitle:(NSString *)title;
- (void)setTitle:(NSString *)title value:(NSString *)value;
- (void)setValue:(NSString *)value;
- (NSString *)value;

@end
