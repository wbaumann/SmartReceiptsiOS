//
//  PDFPage.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripReportHeader;
@class PDFReportTable;
@class PDFImageView;

// Page size constants:
static const CGRect kPDFPageA4Portrait = {
    .origin = { .x = 0.0f, .y = 0.0f },
    .size   = { .width = 595.0f, .height = 842.0f }
};
static const CGRect kPDFPageA4Landscape = {
    .origin = { .x = 0.0f, .y = 0.0f },
    .size   = { .width = 842.0f, .height = 595.0f }
};

/// Page instance
///
/// Dynamically resizes its subviews according to the frame
@interface PDFPage : UIView

- (void)appendHeader:(TripReportHeader *)header;
- (void)appendTable:(PDFReportTable *)table;
- (void)appendImage:(PDFImageView *)imageView;
- (CGFloat)remainingSpace;
- (BOOL)isEmpty;
- (void)appendFullPageElement:(UIView *)view;

@end
