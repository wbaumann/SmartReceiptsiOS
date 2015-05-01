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
@property (nonatomic, strong, readonly) id<InputValidation> inputValidation;

- (NSString *)value;
- (void)activateDecimalEntryMode;

@end
