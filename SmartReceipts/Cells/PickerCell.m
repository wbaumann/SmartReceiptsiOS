//
//  PickerCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIAlertView-Blocks/UIAlertView+Blocks.h>
#import "PickerCell.h"
#import "Pickable.h"
#import "WBCustomization.h"

@interface PickerCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;
@property (nonatomic, copy) NSString *warningTitle;
@property (nonatomic, copy) NSString *warningMessage;

@end

@implementation PickerCell

- (void)awakeFromNib {
    [self.valueLabel setTextColor:[WBCustomization themeColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    [self.titleLabel setText:title];
    [self.valueLabel setText:value];
}

- (void)setValue:(NSString *)value {
    [self.valueLabel setText:value];
}

- (NSString *)value {
    return self.valueLabel.text;
}

- (void)removeWarning {
    [self setAccessoryView:nil];
}

- (void)addWarningWithTitle:(NSString *)title message:(NSString *)message {
    [self setWarningTitle:title];
    [self setWarningMessage:message];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(warningButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"791-warning-toolbar"] forState:UIControlStateNormal];
    [button sizeToFit];
    [self setAccessoryView:button];
}

- (void)warningButtonPressed {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.warningTitle
                                                        message:self.warningMessage
                                               cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                               otherButtonItems:nil];
    [alertView show];
}

- (void)setPickableValue:(id <Pickable>)pickableValue {
    _pickableValue = pickableValue;

    [self.valueLabel setText:pickableValue.presentedValue];
}

@end
