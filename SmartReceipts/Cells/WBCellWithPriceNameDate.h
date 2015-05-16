//
//  WBTripCell.h
//  SmartReceipts
//
//  Created on 30/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBCellWithPriceNameDate : UITableViewCell

@property (weak, nonatomic, readonly) UILabel *priceField;
@property (weak, nonatomic, readonly) UILabel *nameField;
@property (weak, nonatomic, readonly) UILabel *dateField;
@property (weak, nonatomic, readonly) NSLayoutConstraint *priceWidthConstraint;

@end
