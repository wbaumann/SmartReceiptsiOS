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
    [WBPdfDrawer renderPage:self.page inContext:UIGraphicsGetCurrentContext() inRectangle:self.bounds];
}

@end
