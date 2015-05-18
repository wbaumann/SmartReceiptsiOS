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
#import "WBPreferences.h"
#import "Database+Distances.h"
#import "WBReceipt.h"
#import "DistancesToReceiptsConverter.h"
#import "NSString+Validation.h"

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

    [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"Distance Traveled: %.2f", [self.database totalDistanceTraveledForTrip:self.trip].floatValue]];

    if ([WBPreferences trackCostCenter] && self.trip.costCenter.hasValue) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Cost Center:", nil), self.trip.costCenter]];
    }

    if (self.trip.comment.hasValue) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Report Comment:", nil), self.trip.comment]];
    }

    [self.pdfDrawer drawGap];

    ReportPDFTable *receiptsTable = [[ReportPDFTable alloc] initWithPDFDrawer:self.pdfDrawer columns:[self receiptColumns]];
    [receiptsTable setIncludeHeaders:YES];
    NSArray *rows = [self receipts];
    if ([WBPreferences printDailyDistanceValues]) {
        NSArray *distances = [self.database allDistancesForTrip:self.trip];
        NSArray *receipts = [DistancesToReceiptsConverter convertDistances:distances];
        rows = [rows arrayByAddingObjectsFromArray:receipts];
        rows = [rows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            WBReceipt *one = obj1;
            WBReceipt *two = obj2;
            return [two.dateFromDateMs compare:one.dateFromDateMs];
        }];
    }

    [receiptsTable appendTableWithRows:rows];

    if (![WBPreferences printDistanceTable]) {
        return;
    }

    NSArray *distances = [self distances];
    if (distances.count == 0) {
        return;
    }

    [self.pdfDrawer drawGap];

    ReportPDFTable *distancesTable = [[ReportPDFTable alloc] initWithPDFDrawer:self.pdfDrawer columns:[self distanceColumns]];
    [distancesTable setIncludeHeaders:YES];
    [distancesTable appendTableWithRows:distances];
}

@end
