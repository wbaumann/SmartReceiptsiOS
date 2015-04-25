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

@implementation TripCSVGenerator

- (BOOL)generateToPath:(NSString *)outputPath {
    NSMutableString *content = [NSMutableString string];

    ReportCSVTable *receiptsTable = [[ReportCSVTable alloc] initWithContent:content columns:[self receiptColumns]];
    [receiptsTable setIncludeHeaders:[WBPreferences includeCSVHeaders]];

    [receiptsTable appendTableWithRows:[self receipts]];

    NSError *writeError = nil;
    BOOL writeSuccess = [content writeToFile:outputPath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    if (writeError) {
        NSLog(@"CSV write error:%@", writeError);
    }

    return writeSuccess;
}

@end
