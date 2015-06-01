//
//  ReportPDFGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportPDFGenerator.h"
#import "Database.h"
#import "Database+PDFColumns.h"

@implementation ReportPDFGenerator

- (NSArray *)receiptColumns {
    return [[Database sharedInstance] allPDFColumns];
}

@end
