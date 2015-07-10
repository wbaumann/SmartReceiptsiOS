//
//  ReportTable.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 10/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFReportTable : UIView

@property (nonatomic, strong) NSArray *columns;

- (void)appendValues:(NSArray *)values;
- (void)buildTable;

@end
