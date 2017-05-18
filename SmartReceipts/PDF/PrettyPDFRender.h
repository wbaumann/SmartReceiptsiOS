//
//  PrettyPDFRender.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrettyPDFRender : NSObject

/**
 'true' whenever there is no enough space (width) to place all columns within page
 */
@property (nonatomic, assign, readonly) BOOL tableHasTooManyColumns;

@property (nonatomic, assign) BOOL landscapePreferred;

/**
 Creates a PDF-based graphics context that targets a file at the specified path

 @param path the specified path
 @return 'true' if context created successfully
 */
- (BOOL)setOutputPath:(NSString *)path;

/**
 Renders all previously added pages and closes PDF-based graphics context

 @return 'true' on success
 */
- (BOOL)renderPages;

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
