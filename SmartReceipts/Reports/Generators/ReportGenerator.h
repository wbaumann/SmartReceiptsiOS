//
//  ReportGenerator.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBTrip;

@interface ReportGenerator : NSObject

@property (nonatomic, strong, readonly) WBTrip *trip;

- (instancetype)initWithTrip:(WBTrip *)trip;
- (BOOL)generateToPath:(NSString *)outputPath;
- (NSArray *)receiptColumns;
- (NSArray *)receipts;
- (NSArray *)distanceColumns;
- (NSArray *)distances;

@end
