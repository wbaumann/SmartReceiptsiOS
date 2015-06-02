//
//  DistanceSummaryCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "DistanceSummaryCell.h"

@interface DistanceSummaryCell ()

@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *priceWidthConstraint;
@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end

@implementation DistanceSummaryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPriceLabelWidth:(CGFloat)width {
    [self.priceWidthConstraint setConstant:width];
    [self layoutIfNeeded];
}

@end
