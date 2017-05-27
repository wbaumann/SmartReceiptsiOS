//
//  ReceiptColumnReimbursable
//  SmartReceipts
//
//  Created by Jaanus Siim on 24/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReceiptColumnReimbursable.h"
#import "WBReceipt.h"
#import "WBTrip.h"

@implementation ReceiptColumnReimbursable

- (NSString *)valueFromReceipt:(WBReceipt *)receipt forCSV:(BOOL)forCSV {
    return [receipt isReimbursable] ? NSLocalizedString(@"receipt.column.reimbursable.value.yes", nil) : NSLocalizedString(@"receipt.column.reimbursable.value.no", nil);
}

@end
