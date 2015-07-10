//
//  TableContentRow.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableContentRow : UIView

@property (nonatomic, strong, readonly) UILabel *contentLabel;

- (CGFloat)widthForValue:(NSString *)value;
- (void)setValue:(NSString *)value;
- (CGFloat)heightForValue:(NSString *)value usingWidth:(CGFloat)width;

@end
