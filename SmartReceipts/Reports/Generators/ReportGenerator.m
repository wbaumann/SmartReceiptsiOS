//
//  ReportGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "ReportGenerator.h"
#import "Constants.h"
#import "WBTrip.h"
#import "WBDB.h"
#import "WBReportUtils.h"
#import "ReceiptIndexer.h"

@interface ReportGenerator ()

@property (nonatomic, strong) WBTrip *trip;

@end

@implementation ReportGenerator

- (instancetype)initWithTrip:(WBTrip *)trip {
    self = [super init];
    if (self) {
        _trip = trip;
    }
    return self;
}

- (BOOL)generateToPath:(NSString *)outputPath {
    ABSTRACT_METHOD
    return NO;
}

- (NSArray *)receiptColumns {
    ABSTRACT_METHOD
    return nil;
}

- (NSArray *)receipts {
    NSArray *receipts = [[WBDB receipts] selectAllForTrip:self.trip descending:true];
    return  [ReceiptIndexer indexReceipts:receipts filteredWith:^BOOL(WBReceipt *receipt) {
        return [WBReportUtils filterOutReceipt:receipt];
    }];
}

@end
