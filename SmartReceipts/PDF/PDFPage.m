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

CGFloat const ElementsSpacing = 16;

@interface PDFPage ()

@property (nonatomic, strong) IBOutlet UIView *topLine;
@property (nonatomic, strong) IBOutlet UIView *bottomLine;
@property (nonatomic, assign) CGFloat contentOffset;

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

@end
