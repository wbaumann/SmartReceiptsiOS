//
//  TitledTextEntryCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TitledTextEntryCell.h"

@interface TitledTextEntryCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation TitledTextEntryCell

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

- (void)setPlaceholder:(NSString *)placeholder {
    [self.entryField setPlaceholder:placeholder];
}


@end
