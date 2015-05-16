//
//  WBTripCell.h
//  SmartReceipts
//
//  Created on 30/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBCellWithPriceNameDate : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceField;
@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *dateField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceWidthConstraint;

@end
