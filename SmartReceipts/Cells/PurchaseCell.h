//
//  PurchaseCell.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface PurchaseCell : UITableViewCell

- (void)markPurchased;
- (void)markSpinning;
- (void)setPriceString:(NSString *)priceString;
- (void)markErrorWithTapHandler:(ActionBlock)tapHandler;

@end
