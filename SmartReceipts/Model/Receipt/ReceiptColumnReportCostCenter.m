//
//  ReceiptColumnReportCostCenter.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnReportCostCenter.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "NSString+Validation.h"

@implementation ReceiptColumnReportCostCenter

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    NSString *costCenter = receipt.trip.costCenter;
    return costCenter.hasValue ? costCenter : @"";
}

@end
