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
#import "PricesCollection.h"
#import "Distance.h"

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

    PricesCollection *netTotal = [[PricesCollection alloc] init];
    PricesCollection *receiptTotal = [[PricesCollection alloc] init];
    PricesCollection *expensableTotal = [[PricesCollection alloc] init];
    PricesCollection *noTaxesTotal = [[PricesCollection alloc] init];
    PricesCollection *taxesTotal = [[PricesCollection alloc] init];
    PricesCollection *distanceTotal = [[PricesCollection alloc] init];

    NSArray *receipts = [self receipts];

    BOOL pricesPreTax = [WBPreferences enteredPricePreTax];
    BOOL reportOnlyExpensable = [WBPreferences onlyIncludeExpensableReceiptsInReports];

    for (WBReceipt *receipt in receipts) {
        if (reportOnlyExpensable && !receipt.isExpensable) {
            continue;
        }

        [netTotal addPrice:receipt.price];
        [receiptTotal addPrice:receipt.price];
        [noTaxesTotal addPrice:receipt.price];
        [noTaxesTotal subtractPrice:receipt.tax];
        [taxesTotal addPrice:receipt.tax];
        if (pricesPreTax) {
            [netTotal addPrice:receipt.tax];
        }
        if (reportOnlyExpensable) {
            [expensableTotal addPrice:receipt.price];
        }
    }

    NSArray *distances = [self.database allDistancesForTrip:self.trip];
    for (Distance *distance in distances) {
        [netTotal addPrice:distance.totalRate];
        [distanceTotal addPrice:distance.totalRate];
    }

    ReportPDFTable *receiptsTable = [[ReportPDFTable alloc] initWithPDFDrawer:self.pdfDrawer columns:[self receiptColumns]];
    [receiptsTable setIncludeHeaders:YES];
    if ([WBPreferences printDailyDistanceValues]) {
        NSArray *distanceReceipts = [DistancesToReceiptsConverter convertDistances:distances];
        receipts = [receipts arrayByAddingObjectsFromArray:distanceReceipts];
        receipts = [receipts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            WBReceipt *one = obj1;
            WBReceipt *two = obj2;
            return [two.date compare:one.date];
        }];
    }

    [receiptsTable appendTableWithRows:receipts];

    if (![WBPreferences printDistanceTable]) {
        return;
    }

    if (distances.count == 0) {
        return;
    }

    [self.pdfDrawer drawGap];

    ReportPDFTable *distancesTable = [[ReportPDFTable alloc] initWithPDFDrawer:self.pdfDrawer columns:[self distanceColumns]];
    [distancesTable setIncludeHeaders:YES];
    [distancesTable appendTableWithRows:distances];
}

@end
