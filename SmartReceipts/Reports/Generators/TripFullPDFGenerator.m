//
//  TripFullPDFGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TripFullPDFGenerator.h"
#import "WBPdfDrawer.h"
#import "WBTrip.h"
#import "WBDateFormatter.h"
#import "ReportPDFTable.h"

@implementation TripFullPDFGenerator

- (BOOL)generateToPath:(NSString *)outputPath {
    if (![self.pdfDrawer beginDrawingToFile:outputPath]) {
        return NO;
    }

    [self appendSummaryAndTables];

    [self appendImages];

    [self.pdfDrawer endDrawing];

    return YES;
}

- (void)appendSummaryAndTables {
    [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@  \u2022  %@",
                                                           [self.trip priceWithCurrencyFormatted], [self.trip name]]];

    [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"From: %@ To: %@",
                                                           [self.dateFormatter formattedDate:[self.trip startDate] inTimeZone:[self.trip startTimeZone]],
                                                           [self.dateFormatter formattedDate:[self.trip endDate] inTimeZone:[self.trip endTimeZone]]
    ]];

    [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"Distance Traveled: %.2f",
                                                           [self.trip miles]]];

    [self.pdfDrawer drawGap];

    ReportPDFTable *receiptsTable = [[ReportPDFTable alloc] initWithPDFDrawer:self.pdfDrawer columns:[self receiptColumns]];
    [receiptsTable setIncludeHeaders:YES];
    [receiptsTable appendTableWithRows:[self receipts]];
}

@end
