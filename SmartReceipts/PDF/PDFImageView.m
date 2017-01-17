//
//  PDFImageView.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 13/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PDFImageView.h"
#import "WBImageUtils.h"

@interface PDFImageView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation PDFImageView

const CGFloat DEFAULT_COMPRESSION_QUALITY = 0.7;

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

- (void)adjustImageSize {
    UIImage *image = self.imageView.image;
    UIImage *scaled = [WBImageUtils image:image scaledToFitSize:self.bounds.size];
    UIImage *scaledAndCompressed = [WBImageUtils compressImage:scaled withRatio:DEFAULT_COMPRESSION_QUALITY];
    [self.imageView setImage:scaledAndCompressed];
    if (!scaledAndCompressed.hasContent) {
        LOGGER_ERROR(@"Actually no image content! Label:%@", _titleLabel.text);
    }
}

@end
