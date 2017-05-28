//
//  TripCSVGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TripCSVGenerator.h"
#import "ReportCSVTable.h"
#import "WBPreferences.h"
#import "NSMutableString+Extensions.h"
#import "DistancesToReceiptsConverter.h"

@implementation TripCSVGenerator

- (BOOL)generateToPath:(NSString *)outputPath {
    NSString *content = [self generateContent];
    
    NSError *writeError = nil;
    BOOL writeSuccess = [content writeToFile:outputPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    
    if (writeSuccess) {
        return YES;
    } else {
        LOGGER_ERROR(@"CSV write error:%@", writeError);
        return NO;
    }
}

- (NSString *)generateContent {
    NSMutableString *content = [NSMutableString mutableStringWithByteOrderMark];
    [self appendReceiptsTable:content];
    [self appendDistancesTable:content];
    return content;
}

- (void)appendReceiptsTable:(NSMutableString *)content {
    ReportCSVTable *receiptsTable = [[ReportCSVTable alloc] initWithContent:content columns:[self receiptColumns]];
    [receiptsTable setIncludeHeaders:[WBPreferences includeCSVHeaders]];
    
    NSArray *receipts = [self receipts];
    if ([WBPreferences printDailyDistanceValues]) {
        NSArray *distanceReceipts = [DistancesToReceiptsConverter convertDistances:[self distances]];
        receipts = [receipts arrayByAddingObjectsFromArray:distanceReceipts];
        receipts = [receipts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            WBReceipt *one = obj1;
            WBReceipt *two = obj2;
            return [two.date compare:one.date];
        }];
    }

    [receiptsTable appendTableWithRows:receipts];
}

- (void)appendDistancesTable:(NSMutableString *)content {
    if (![WBPreferences printDistanceTable]) {
        return;
    }

    NSArray *distances = [self distances];
    if (distances.count == 0) {
        return;
    }

    [content appendString:@"\n\n"];

    ReportCSVTable *receiptsTable = [[ReportCSVTable alloc] initWithContent:content columns:[self distanceColumns]];
    [receiptsTable setIncludeHeaders:[WBPreferences includeCSVHeaders]];
    [receiptsTable appendTableWithRows:distances];
}

@end
