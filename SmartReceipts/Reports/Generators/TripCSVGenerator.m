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

    [receiptsTable appendTableWithRows:[self receipts]];
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
