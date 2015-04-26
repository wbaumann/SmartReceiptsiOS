//
//  TripImagesPDFGenerator.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportGenerator.h"

@class WBPdfDrawer;

@interface TripImagesPDFGenerator : ReportGenerator

@property (nonatomic, strong, readonly) WBPdfDrawer *pdfDrawer;

- (void)appendImages;

@end
