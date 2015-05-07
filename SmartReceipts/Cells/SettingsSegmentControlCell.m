//
//  SettingsSegmentControlCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "SettingsSegmentControlCell.h"

static CGFloat const SegmentTitlePadding = 20;
static CGFloat const SegmentTitleMinWidth = 50;

@interface SettingsSegmentControlCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *segmentWidthConstraint;

@end

@implementation SettingsSegmentControlCell


- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setValues:(NSArray *)values selected:(NSUInteger)selectedIndex {
    UIFont *testFont = [UIFont boldSystemFontOfSize:14];

    CGFloat width = 0;

    [self.segmentedControl removeAllSegments];
    for (NSUInteger index = 0; index < values.count; index++) {
        NSString *segmentTitle = values[index];
        [self.segmentedControl insertSegmentWithTitle:segmentTitle atIndex:index animated:NO];

        CGFloat titleWidth = CGRectGetWidth([segmentTitle boundingRectWithSize:CGSizeMake(1000, 1000) options:0 attributes:@{NSFontAttributeName : testFont} context:nil]);
        titleWidth += SegmentTitlePadding;
        titleWidth = MAX(titleWidth, SegmentTitleMinWidth);
        width += titleWidth;
    }

    [self.segmentedControl setSelectedSegmentIndex:selectedIndex];
    [self.segmentWidthConstraint setConstant:width];
    [self.segmentedControl layoutIfNeeded];
}

- (NSString *)selectedValue {
    return [self.segmentedControl titleForSegmentAtIndex:(NSUInteger) self.segmentedControl.selectedSegmentIndex];
}

- (NSInteger)selectedSegmentIndex {
    return self.segmentedControl.selectedSegmentIndex;
}

@end
