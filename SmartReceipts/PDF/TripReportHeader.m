//
//  TripReportHeader.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TripReportHeader.h"

CGFloat const HeaderRowsSpacing = 8;

@interface TripReportHeader ()

@property (nonatomic, strong) IBOutlet UILabel *tripNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *rowPrototype;
@property (nonatomic, assign) CGFloat yOffset;

@end

@implementation TripReportHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tripNameLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [self.rowPrototype removeFromSuperview];
}

- (void)setTripName:(NSString *)name {
    [self.tripNameLabel setText:name];
    [self adjustLabelHeightToFitAndPosition:self.tripNameLabel];
}

- (void)appendRow:(NSString *)row {
    UILabel *label = [[UILabel alloc] initWithFrame:self.rowPrototype.bounds];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:11]];
    [label setText:row];
    [self addSubview:label];
    [self adjustLabelHeightToFitAndPosition:label];
}

- (void)adjustLabelHeightToFitAndPosition:(UILabel *)label {
    CGFloat fitHeight = [label sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)].height;

    self.yOffset += HeaderRowsSpacing;

    CGRect labelFrame = label.frame;
    labelFrame.origin.y = self.yOffset;
    labelFrame.size.height = fitHeight;
    [label setFrame:labelFrame];

    self.yOffset += fitHeight;

    CGRect myFrame = self.frame;
    myFrame.size.height = self.yOffset;
    [self setFrame:myFrame];
}

@end
