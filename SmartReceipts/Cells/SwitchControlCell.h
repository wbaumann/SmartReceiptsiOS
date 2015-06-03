//
//  SwitchControlCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchControlCell : UITableViewCell

- (void)setTitle:(NSString *)title;
- (void)setSwitchOn:(BOOL)isOn;
- (void)setSwitchOn:(BOOL)isOn animated:(BOOL)animated;
- (BOOL)isSwitchOn;

@end
