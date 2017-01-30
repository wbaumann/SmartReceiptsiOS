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
    
    // The problem is that we can't use default CGContext for drawing a pdf on iPhone 7 and newer with iOS10 (extended color devices)
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
        // This method renders within the current context:
        // [pdfImg drawInRect:rect]
        // so here is another way:
        
        // Clear subviews (just in case, to be sure that pdf wouldn't be rendered twice)
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
        
        // add already rendered PDF file as image
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
