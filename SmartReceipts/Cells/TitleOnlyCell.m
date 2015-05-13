//
//  TitleOnlyCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TitleOnlyCell.h"

@implementation TitleOnlyCell

- (void)setTitle:(NSString *)title {
    [self.textLabel setText:title];
}

@end
