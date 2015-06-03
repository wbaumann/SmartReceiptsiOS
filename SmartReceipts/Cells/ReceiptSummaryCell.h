//
//  ReceiptSummaryCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptSummaryCell : UITableViewCell

@property (weak, nonatomic, readonly) UILabel *priceField;
@property (weak, nonatomic, readonly) UILabel *nameField;
@property (weak, nonatomic, readonly) UILabel *dateField;
@property (weak, nonatomic, readonly) NSLayoutConstraint *priceWidthConstraint;
@property (weak, nonatomic, readonly) UILabel *categoryLabel;

@end
