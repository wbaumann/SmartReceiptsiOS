//
//  PDFPageRenderView.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 14/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PDFPageRenderView.h"
#import "WBPdfDrawer.h"

@interface PDFPageRenderView ()

@end

@implementation PDFPageRenderView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    LOGGER_INFO(@"UIGraphicsGetCurrentContext(): %@", context);
    
    if ([UIGraphicsImageRenderer class]) {
        LOGGER_INFO(@"UIGraphicsImageRenderer available");
        
        UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
        [format setPrefersExtendedRange:NO]; // disable rendering extended colors
        
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithBounds:rect format:format];
        
        // generate UIImage from current pdf page
        UIImage *pdfImg = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            LOGGER_INFO(@"UIGraphicsImageRendererContext: %@", rendererContext);
            [WBPdfDrawer renderPage:self.page inContext:rendererContext.CGContext inRectangle:self.bounds];
        }];
        
        // Draw image
//        [pdfImg drawInRect:rect];
#warning bad practice:
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = pdfImg;
        [self addSubview:imageView];
        
        if (pdfImg == nil) {
            LOGGER_ERROR(@"UIGraphicsImageRenderer, imageWithActions(block) -> NULL result");
        }
        
    } else {
        // Legacy version
        [WBPdfDrawer renderPage:self.page inContext:context inRectangle:self.bounds];
    }
}

@end
