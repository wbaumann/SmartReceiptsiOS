//
//  TextEntryCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputValidation;

@interface TextEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *entryField;
@property (nonatomic, strong) id<InputValidation> inputValidation;

- (NSString *)value;
- (void)activateDecimalEntryMode;
- (void)activateDecimalEntryModeWithDecimalPlaces:(NSUInteger)decimalPlaces;
- (void)activateNumberEntryMode;
- (void)activateEmailMode;
- (void)setValue:(NSString *)value;
- (void)addAccessoryViewWithNegativeSwitch;

@end
