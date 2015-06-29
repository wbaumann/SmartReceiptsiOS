//
//  PurchaseCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PurchaseCell.h"
#import "WBCustomization.h"
#import "Constants.h"

@interface PurchaseCell ()

@property (nonatomic, copy) ActionBlock errorTapHandler;

@end

@implementation PurchaseCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setTintColor:[WBCustomization themeColor]];
}

- (void)markPurchased {
    [self.detailTextLabel setText:@" "];
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)markSpinning {
    [self.detailTextLabel setText:@" "];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    [spinner setColor:[WBCustomization themeColor]];
    [self setAccessoryView:spinner];
}

- (void)setPriceString:(NSString *)priceString {
    [self setAccessoryView:nil];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self.detailTextLabel setText:priceString];
    [self.detailTextLabel setTextColor:[WBCustomization themeColor]];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)markErrorWithTapHandler:(ActionBlock)tapHandler {
    [self setErrorTapHandler:tapHandler];
    [self.detailTextLabel setText:@" "];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTintColor:[UIColor redColor]];
    [button setImage:[UIImage imageNamed:@"724-info-toolbar"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(errorButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self setAccessoryView:button];
}

- (void)errorButtonPressed {
    self.errorTapHandler();
}

@end
