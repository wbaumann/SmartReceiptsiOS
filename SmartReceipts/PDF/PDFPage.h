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

@interface PDFPage : UIView

- (void)appendHeader:(TripReportHeader *)header;
- (void)appendTable:(PDFReportTable *)table;

@end
