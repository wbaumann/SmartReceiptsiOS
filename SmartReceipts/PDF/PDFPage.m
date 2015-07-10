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

CGFloat const ElementsSpacing = 16;

@interface PDFPage ()

@property (nonatomic, strong) IBOutlet UIView *topLine;
@property (nonatomic, strong) IBOutlet UIView *bottomLine;
@property (nonatomic, assign) CGFloat contentOffset;

@end

@implementation PDFPage

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.topLine setBackgroundColor:[WBCustomization themeColor]];
    [self.bottomLine setBackgroundColor:[WBCustomization themeColor]];

    self.contentOffset = self.topLine.frame.origin.y + CGRectGetHeight(self.topLine.frame) + ElementsSpacing;
}


- (void)appendHeader:(TripReportHeader *)header {
    CGRect frame = header.frame;
    frame.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2;
    frame.origin.y = self.contentOffset;
    [header setFrame:frame];
    [self addSubview:header];

    self.contentOffset += CGRectGetHeight(frame) + ElementsSpacing;
}

@end
