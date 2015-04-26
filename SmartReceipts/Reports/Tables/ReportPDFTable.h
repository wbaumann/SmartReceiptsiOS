//
//  ReportPDFTable.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportTable.h"

@class WBPdfDrawer;

@interface ReportPDFTable : ReportTable

- (instancetype)initWithPDFDrawer:(WBPdfDrawer *)drawer columns:(NSArray *)columns;

@end
