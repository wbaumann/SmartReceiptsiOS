//
//  ReportPDFGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportPDFGenerator.h"
#import "WBDB.h"

@implementation ReportPDFGenerator

- (NSArray *)receiptColumns {
    return [[WBDB pdfColumns] selectAll];
}

@end
