//
//  PickerCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PickerCell.h"

@interface PickerCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;

@end

@implementation PickerCell

- (void)awakeFromNib {
    // Initialization code
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

@end
