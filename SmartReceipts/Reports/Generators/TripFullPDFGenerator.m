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
#import "Distance.h"
#import "Constants.h"
#import "PrettyPDFRender.h"
#import "SmartReceipts-Swift.h"

@implementation TripFullPDFGenerator

- (BOOL)generateToPath:(NSString *)outputPath {
    // render tables in landscape orientation if needed
    self.pdfRender.landscapePreferred = [WBPreferences printReceiptTableLandscape];
    
    if (![self.pdfRender setOutputPath:outputPath]) {
        return NO; // error
    }
    
    [self appendSummaryAndTables];
    
    // always render fullPageElements and images in protrait orientation
    self.pdfRender.landscapePreferred = NO;
    [self.pdfRender startNextPage];
    [self appendImages];

    BOOL success = [self.pdfRender renderPages];
    return success;
}

- (void)appendSummaryAndTables {
    PricesCollection *netTotal = [[PricesCollection alloc] init];
    PricesCollection *receiptTotal = [[PricesCollection alloc] init];
    PricesCollection *reimbursableTotal = [[PricesCollection alloc] init];
    PricesCollection *noTaxesTotal = [[PricesCollection alloc] init];
    PricesCollection *taxesTotal = [[PricesCollection alloc] init];
    PricesCollection *distanceTotal = [[PricesCollection alloc] init];

    NSArray *receipts = [self receipts];

    BOOL pricesPreTax = [WBPreferences enteredPricePreTax];
    BOOL reportOnlyReimbursable = [WBPreferences onlyIncludeReimbursableReceiptsInReports];

    for (WBReceipt *receipt in receipts) {
        if (reportOnlyReimbursable && !receipt.isReimbursable) {
            continue;
        }

        [netTotal addPrice:receipt.targetPrice];
        [receiptTotal addPrice:receipt.targetPrice];
        [noTaxesTotal addPrice:receipt.targetPrice];
        [noTaxesTotal subtractPrice:receipt.targetTax];
        [taxesTotal addPrice:receipt.targetTax];
        if (pricesPreTax) {
            [netTotal addPrice:receipt.targetTax];
        }
        if (receipt.isReimbursable) {
            [reimbursableTotal addPrice:receipt.targetPrice];
        }
    }

    NSArray *distances = [self distances];

    for (Distance *distance in distances) {
        [netTotal addPrice:distance.totalRate];
        [distanceTotal addPrice:distance.totalRate];
    }

    [self.pdfRender setTripName:self.trip.name];

    if (![receiptTotal isEqual:netTotal]) {
        [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.receipts.total.label", nil), receiptTotal.currencyFormattedPrice]];
    }

    if ([WBPreferences includeTaxField]) {
        if (pricesPreTax && taxesTotal.hasValue) {
            [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.tax.total.label", nil), taxesTotal.currencyFormattedPrice]];
        } else if (![noTaxesTotal isEqual:receiptTotal] && noTaxesTotal.hasValue) {
            [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.receipts.total.sans.tax.label", nil), noTaxesTotal.currencyFormattedPrice]];
        }
    }

    if (!reportOnlyReimbursable && ![reimbursableTotal isEqual:receiptTotal]) {
        [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.receipts.total.reimbursable.label", nil), reimbursableTotal.currencyFormattedPrice]];
    }

    if (distances.count > 0) {
        [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.distance.total.label", nil), distanceTotal.currencyFormattedPrice]];
    }

    [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.gross.total.label", nil), netTotal.currencyFormattedPrice]];


    [self.pdfRender appendHeaderRow:[NSString stringWithFormat:NSLocalizedString(@"pdf.report.from.to.label.base", nil),
                                                           [self.dateFormatter formattedDate:[self.trip startDate] inTimeZone:[self.trip startTimeZone]],
                                                           [self.dateFormatter formattedDate:[self.trip endDate] inTimeZone:[self.trip endTimeZone]]
    ]];

    if ([WBPreferences trackCostCenter] && self.trip.costCenter.hasValue) {
        [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.const.center.label", nil), self.trip.costCenter]];
    }

    if (self.trip.comment.hasValue) {
        [self.pdfRender appendHeaderRow:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"pdf.report.comment.label", nil), self.trip.comment]];
    }

    if (distances.count > 0) {
        [self.pdfRender appendHeaderRow:[NSString stringWithFormat:NSLocalizedString(@"pdf.report.distance.traveled.label.base", nil), [self.database totalDistanceTraveledForTrip:self.trip].floatValue]];
    }

    [self.pdfRender closeHeader];

    ReportPDFTable *receiptsTable = [[ReportPDFTable alloc] initWithPDFRender:self.pdfRender columns:[self receiptColumns]];
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

    ReportPDFTable *distancesTable = [[ReportPDFTable alloc] initWithPDFRender:self.pdfRender columns:[self distanceColumns]];
    [distancesTable setIncludeHeaders:YES];
    [distancesTable appendTableWithRows:distances];
}

@end
