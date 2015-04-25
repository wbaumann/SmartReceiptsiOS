//
//  ReceiptColumnDate.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <objc/NSObjCRuntime.h>
#import <objc/objc.h>
#import "ReceiptColumnDate.h"
#import "WBReceipt.h"
#import "WBDateFormatter.h"

@interface ReceiptColumnDate ()

@end

@implementation ReceiptColumnDate

- (NSString *)valueFromReceipt:(WBReceipt *)receipt receiptIndex:(NSInteger)receiptIndex forCSV:(BOOL)forCSV {
    return [self.dateFormatter formattedDate:[receipt dateFromDateMs] inTimeZone:[receipt timeZone]];
}

@end
