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
#import "Constants.h"

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
        if (receipt.isExpensable) {
            [expensableTotal addPrice:receipt.price];
        }
    }

    NSArray *distances = [self.database allDistancesForTrip:self.trip];

    SRLog(@"Diatances:%@", distances);

    for (Distance *distance in distances) {
        [netTotal addPrice:distance.totalRate];
        [distanceTotal addPrice:distance.totalRate];
    }

    [self.pdfDrawer drawRowText:self.trip.name];

    if (![receiptTotal isEqual:netTotal]) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.receipts.total.label", nil), receiptTotal.currencyFormattedPrice]];
    }

    if ([WBPreferences includeTaxField]) {
        if (pricesPreTax && taxesTotal.hasValue) {
            [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.tax.total.label", nil), taxesTotal.currencyFormattedPrice]];
        } else if (![noTaxesTotal isEqual:receiptTotal] && noTaxesTotal.hasValue) {
            [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.receipts.total.sans.tax.label", nil), noTaxesTotal.currencyFormattedPrice]];
        }
    }

    if (!reportOnlyExpensable && ![expensableTotal isEqual:receiptTotal]) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.receipts.total.expensable.label", nil), expensableTotal.currencyFormattedPrice]];
    }

    if (distances.count > 0) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.distance.total.label", nil), distanceTotal.currencyFormattedPrice]];
    }

    [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.gross.total.label", nil), netTotal.currencyFormattedPrice]];


    [self.pdfDrawer drawRowText:[NSString stringWithFormat:NSLocalizedString(@"pdf.report.from.to.label.base", nil),
                                                           [self.dateFormatter formattedDate:[self.trip startDate] inTimeZone:[self.trip startTimeZone]],
                                                           [self.dateFormatter formattedDate:[self.trip endDate] inTimeZone:[self.trip endTimeZone]]
    ]];

    if ([WBPreferences trackCostCenter] && self.trip.costCenter.hasValue) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.const.center.label", nil), self.trip.costCenter]];
    }

    if (self.trip.comment.hasValue) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.comment.label", nil), self.trip.comment]];
    }

    if (distances.count > 0) {
        [self.pdfDrawer drawRowText:[NSString stringWithFormat:NSLocalizedString(@"pdf.report.distance.traveled.label.base", nil), [self.database totalDistanceTraveledForTrip:self.trip].floatValue]];
    }

    [self.pdfDrawer drawGap];

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
