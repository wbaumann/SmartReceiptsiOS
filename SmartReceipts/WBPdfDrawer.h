//
//  WBPdfDrawer.h
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBPdfDrawer : NSObject

- (BOOL) beginDrawingToFile:(NSString*)fileName;

- (void) endDrawing;

- (void) drawRowText:(NSString*) text;

- (void) drawRowBorderedTexts:(NSArray*) texts;

- (void) drawImage:(UIImage*) image withLabel:(NSString*) text;

- (void) drawFullPageImage:(UIImage*) image withLabel:(NSString*) text;

- (void) drawFullPagePDFPage:(CGPDFPageRef) page withLabel:(NSString*) text;

- (void) drawGap;

@end
