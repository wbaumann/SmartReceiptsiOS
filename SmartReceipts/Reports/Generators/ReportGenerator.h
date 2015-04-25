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

- (instancetype)initWithTrip:(WBTrip *)trip;
- (BOOL)generateToPath:(NSString *)outputPath;
- (NSArray *)receiptColumns;
- (NSArray *)receipts;

@end
