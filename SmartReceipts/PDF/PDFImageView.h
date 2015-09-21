//
//  PDFImageView.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFImageView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;

- (void)fitImageView;
- (void)adjustImageSize;

@end
