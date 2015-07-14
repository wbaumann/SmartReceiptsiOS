//
//  PDFImageView.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PDFImageView.h"

@interface PDFImageView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation PDFImageView

- (void)fitImageView {
    CGSize imageSize = self.imageView.image.size;
    if (imageSize.height > imageSize.width) {
        //do nothing for portrait images
        return;
    }

    CGFloat ratio = imageSize.height / imageSize.width;
    CGFloat height = CGRectGetWidth(self.imageView.frame) * ratio;

    CGRect imageFrame = self.imageView.frame;
    imageFrame.size.height = height;
    [self.imageView setFrame:imageFrame];
}

@end
