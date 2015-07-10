//
//  TableContentRow.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TableContentRow.h"

@interface TableContentRow ()

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@end

@implementation TableContentRow

- (void)setValue:(NSString *)value {
    if (!self.contentLabel) {
        self.contentLabel = [self subviewOfType:[UILabel class]];
    }
    [self.contentLabel setText:value];
}

- (UILabel *)subviewOfType:(Class)typeClass {
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:typeClass]) {
            return sub;
        }
    }

    return nil;
}

- (CGFloat)widthForValue:(NSString *)value {
    [self.contentLabel setText:value];
    CGSize fitSize = [self.contentLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 100)];
    return fitSize.width + CGRectGetWidth(self.frame) - CGRectGetWidth(self.contentLabel.frame);
}

- (CGFloat)heightForValue:(NSString *)value usingWidth:(CGFloat)width {
    [self.contentLabel setText:value];
    CGFloat labelWidth = width - (CGRectGetWidth(self.frame) - CGRectGetWidth(self.contentLabel.frame));
    CGSize fitSize = [self.contentLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
    return fitSize.height + (CGRectGetHeight(self.frame) - CGRectGetHeight(self.contentLabel.frame));
}

@end
