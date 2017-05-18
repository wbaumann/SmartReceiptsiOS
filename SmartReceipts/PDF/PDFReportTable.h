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
@property (nonatomic, assign, readonly) NSUInteger rowsAdded;
/**
 'true' whenever there is no enough space to place all columns 
 inside curent page width
 */
@property (nonatomic, assign, readonly) BOOL hasTooManyColumnsToFitWidth;

- (void)appendValues:(NSArray *)values;
/**
 Bulds pdf table within given page
 
 @param availableSpace available vertical space (points)
 @return 'true' when table fits within current page (fully added), 
         'false' - too big table, one more page is needed (partial table)
 */
- (BOOL)buildTable:(CGFloat)availableSpace;

@end
