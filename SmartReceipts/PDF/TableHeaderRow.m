//
//  TableHeaderRow.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TableHeaderRow.h"

@interface TableHeaderRow ()

@property (nonatomic, strong) IBOutlet UIView *bottomSeparatorView;

@end

IB_DESIGNABLE
@implementation TableHeaderRow

- (void)awakeFromNib {
    [super awakeFromNib];

    UIColor *styleColor = [Customization reportPDFStyleColor];
    [self.contentLabel setTextColor:styleColor];
    [self setBackgroundColor:[styleColor colorWithAlphaComponent:0.2]];
    [self.bottomSeparatorView setBackgroundColor:styleColor];
}

@end
