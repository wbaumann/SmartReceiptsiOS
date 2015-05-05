//
//  DistanceSummaryCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistanceSummaryCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *rateLabel;
@property (nonatomic, strong, readonly) UILabel *destinationLabel;
@property (nonatomic, strong, readonly) UILabel *totalLabel;
@property (nonatomic, strong, readonly) UILabel *dateLabel;

- (void)setPriceLabelWidth:(CGFloat)width;

@end
