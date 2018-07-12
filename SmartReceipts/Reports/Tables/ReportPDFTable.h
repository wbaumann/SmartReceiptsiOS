//
//  ReportPDFTable.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 25/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportTable.h"

@class PrettyPDFRender;

@interface ReportPDFTable : ReportTable

- (instancetype)initWithTitle:(NSString *)title PDFRender:(PrettyPDFRender *)drawer columns:(NSArray *)columns;
- (instancetype)initWithPDFRender:(PrettyPDFRender *)drawer columns:(NSArray *)columns;

@end
