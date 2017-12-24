//
//  ReceiptColumnDate.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnDate.h"
#import "WBReceipt.h"
#import "WBDateFormatter.h"

@interface ReceiptColumnDate ()

@end

@implementation ReceiptColumnDate

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [self.dateFormatter formattedDate:[receipt date] inTimeZone:[receipt timeZone]];
}

- (NSString *)valueForFooter:(NSArray *)rows forCSV:(BOOL)forCSV {
    return [self valueFromReceipt:rows.firstObject forCSV:forCSV];
}

@end
