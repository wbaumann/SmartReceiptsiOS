//
//  RenderedPDFLabel.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "RenderedPDFLabel.h"

@implementation RenderedPDFLabel

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    BOOL isPDF = !CGRectIsEmpty(UIGraphicsGetPDFContextBounds());
    if (!layer.shouldRasterize && isPDF) {
        [self drawRect:self.bounds]; // draw unrasterized
    } else {
        [super drawLayer:layer inContext:ctx];
    }
}

@end
