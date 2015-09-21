//
//  PDFPage.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PDFPage.h"
#import "TripReportHeader.h"
#import "WBCustomization.h"
#import "PDFReportTable.h"
#import "PDFImageView.h"

CGFloat const ElementsSpacing = 16;

@interface PDFPage ()

@property (nonatomic, strong) IBOutlet UIView *topLine;
@property (nonatomic, strong) IBOutlet UIView *bottomLine;
@property (nonatomic, assign) CGFloat contentOffset;
@property (nonatomic, assign) NSUInteger imageIndex;

@end

@implementation PDFPage

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.topLine setBackgroundColor:[WBCustomization reportPDFStyleColor]];
    [self.bottomLine setBackgroundColor:[WBCustomization reportPDFStyleColor]];

    self.contentOffset = self.topLine.frame.origin.y + CGRectGetHeight(self.topLine.frame) + ElementsSpacing;
}

- (void)appendHeader:(TripReportHeader *)header {
    [self appendElement:header];
}

- (void)appendTable:(PDFReportTable *)table {
    [self appendElement:table];
}

- (void)appendElement:(UIView *)element {
    CGRect frame = element.frame;
    frame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2;
    frame.origin.y = self.contentOffset;
    [element setFrame:frame];
    [self addSubview:element];

    self.contentOffset += CGRectGetHeight(frame) + ElementsSpacing;
}

- (CGFloat)remainingSpace {
    return self.bottomLine.frame.origin.y - ElementsSpacing - self.contentOffset;
}

- (BOOL)isEmpty {
    return self.contentOffset <= self.topLine.frame.origin.y + CGRectGetHeight(self.topLine.frame) + ElementsSpacing;
}

- (void)appendImage:(PDFImageView *)imageView {
    CGPoint origin = CGPointZero;
    CGFloat topLineBottom = self.topLine.frame.origin.y + CGRectGetHeight(self.topLine.frame);
    if (self.imageIndex == 0) {
        origin = CGPointMake(CGRectGetMinX(self.topLine.frame), topLineBottom + ElementsSpacing);
    } else if (self.imageIndex == 1) {
        origin = CGPointMake((CGRectGetWidth(self.bounds) + ElementsSpacing) / 2, topLineBottom + ElementsSpacing);
    } else if (self.imageIndex == 2) {
        origin = CGPointMake(CGRectGetMinX(self.topLine.frame), (CGRectGetHeight(self.frame) + ElementsSpacing) / 2);
    } else {
        origin = CGPointMake((CGRectGetWidth(self.bounds) + ElementsSpacing) / 2, (CGRectGetHeight(self.frame) + ElementsSpacing) / 2);
    }

    CGRect frame = imageView.frame;
    frame.origin = origin;
    [imageView setFrame:frame];
    [self addSubview:imageView];

    [imageView adjustImageSize];

    self.imageIndex++;
}

- (void)appendFullPageElement:(UIView *)view {
    [self appendElement:view];
}

@end
