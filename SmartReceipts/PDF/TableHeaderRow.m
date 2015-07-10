//
//  TableHeaderRow.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TableHeaderRow.h"
#import "WBCustomization.h"

@interface TableHeaderRow ()

@property (nonatomic, strong) IBOutlet UIView *bottomSeparatorView;

@end

IB_DESIGNABLE
@implementation TableHeaderRow

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.contentLabel setTextColor:[WBCustomization themeColor]];
    [self setBackgroundColor:[[WBCustomization themeColor] colorWithAlphaComponent:0.2]];
    [self.bottomSeparatorView setBackgroundColor:[WBCustomization themeColor]];
}

@end
