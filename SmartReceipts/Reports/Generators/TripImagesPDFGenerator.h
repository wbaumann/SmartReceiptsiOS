//
//  TripImagesPDFGenerator.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportGenerator.h"
#import "ReportPDFGenerator.h"

@class WBPdfDrawer;
@class WBDateFormatter;

@interface TripImagesPDFGenerator : ReportPDFGenerator

@property (nonatomic, strong, readonly) WBPdfDrawer *pdfDrawer;
@property (nonatomic, strong, readonly) WBDateFormatter *dateFormatter;

- (void)appendImages;

@end
