//
//  PurchaseCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PurchaseCell.h"
#import "WBDateFormatter.h"
#import "NSDate+Calculations.h"

@interface PurchaseCell ()

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, copy) ActionBlock errorTapHandler;
@property (nonatomic, assign) BOOL purchased;

@end

@implementation PurchaseCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setTintColor:[Customization themeColor]];
}

- (void)markPurchased {
    [self setPurchased:YES];
    [self.priceLabel setText:@" "];
    [self setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)markSpinning {
    if (self.purchased) {
        return;
    }

    [self.priceLabel setText:@" "];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    [spinner setColor:[Customization themeColor]];
    [self setAccessoryView:spinner];
}

- (void)setPriceString:(NSString *)priceString {
    if (self.purchased) {
        return;
    }

    [self setAccessoryView:nil];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self.priceLabel setText:priceString];
    [self.priceLabel setTextColor:[Customization themeColor]];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)markErrorWithTapHandler:(ActionBlock)tapHandler {
    if (self.purchased) {
        return;
    }

    [self setErrorTapHandler:tapHandler];
    [self.priceLabel setText:@" "];
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

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setSubscriptionEndDate:(NSDate *)date {
    if (!date) {
        [self.subtitleLabel setText:@""];
        return;
    }

    WBDateFormatter *formatter = [[WBDateFormatter alloc] init];
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        [formatter.formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    NSString *formattedDate = [formatter formattedDate:date inTimeZone:[NSTimeZone localTimeZone]];
    [self.subtitleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"settings.purchase.subscription.valid.until.label.base", nil), formattedDate]];
    if ([date isBeforeDate:[NSDate date]]) {
        [self.subtitleLabel setTextColor:[UIColor redColor]];
    } else {
        [self.subtitleLabel setTextColor:[UIColor blackColor]];
    }
}

@end
