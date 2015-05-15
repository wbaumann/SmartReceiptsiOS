//
//  SwitchControlCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 06/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/objc.h>
#import "SwitchControlCell.h"

@interface SwitchControlCell ()

@property (nonatomic, strong) IBOutlet UISwitch *switchControl;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation SwitchControlCell

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

- (void)setSwitchOn:(BOOL)isOn {
    [self.switchControl setOn:isOn];
}

- (BOOL)isSwitchOn {
    return self.switchControl.isOn;
}

@end
