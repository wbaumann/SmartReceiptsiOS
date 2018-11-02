//
//  ReceiptColumnReportComment.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 18/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnReportComment.h"
#import "WBReceipt.h"
#import "WBTrip.h"
#import "NSString+Validation.h"

@implementation ReceiptColumnReportComment

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    NSString *comment = receipt.trip.comment;
    return comment.hasValue ? comment : @"";
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return [self valueFromReceipt:rows.firstObject forCSV:forCSV];
}

@end
