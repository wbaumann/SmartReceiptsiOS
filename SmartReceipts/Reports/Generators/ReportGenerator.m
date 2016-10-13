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
#import "WBReportUtils.h"
#import "ReceiptIndexer.h"
#import "Database+Distances.h"
#import "FetchedModelAdapter.h"
#import "DistanceColumn.h"
#import "Database+Receipts.h"

@interface ReportGenerator ()

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong) Database *database;

@end

@implementation ReportGenerator

- (instancetype)initWithTrip:(WBTrip *)trip database:(Database *)database {
    self = [super init];
    if (self) {
        _trip = trip;
        _database = database;
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
    NSArray *receipts = [self.database allReceiptsForTrip:self.trip ascending:true];
    return  [ReceiptIndexer indexReceipts:receipts filteredWith:^BOOL(WBReceipt *receipt) {
        return [WBReportUtils filterOutReceipt:receipt];
    }];
}

- (NSArray *)distanceColumns {
    return [DistanceColumn allColumns];
}

- (NSArray *)distances {
    FetchedModelAdapter *distances = [self.database fetchedAdapterForDistancesInTrip:self.trip ascending:true];
    return [distances allObjects];
}

@end
