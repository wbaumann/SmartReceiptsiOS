//
//  SettingsSegmentControlCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/NSObjCRuntime.h>

@interface SettingsSegmentControlCell : UITableViewCell

- (void)setTitle:(NSString *)title;
- (void)setValues:(NSArray *)values selected:(NSUInteger)selectedIndex;
- (NSString *)selectedValue;
- (NSInteger)selectedSegmentIndex;

@end
