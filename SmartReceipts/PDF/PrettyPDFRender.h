//
//  PrettyPDFRender.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrettyPDFRender : NSObject

- (BOOL)setOutputPath:(NSString *)path;
- (void)renderPages;
- (void)setTripName:(NSString *)tripName;
- (void)appendHeaderRow:(NSString *)row;
- (void)closeHeader;
- (void)startTable;
- (void)appendTableHeaders:(NSArray *)columnNames;
- (void)appendTableColumns:(NSArray *)rowValues;
- (void)closeTable;
- (void)startNextPage;
- (void)appendImage:(UIImage *)image withLabel:(NSString *)label;
- (void)appendFullPageImage:(UIImage *)image withLabel:(NSString *)label;
- (void)appendPDFPage:(CGPDFPageRef)page withLabel:(NSString *)label;

@end
