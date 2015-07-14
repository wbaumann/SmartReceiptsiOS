//
//  PDFPageRenderView.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 14/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFPageRenderView : UIView

@property (nonatomic, assign) CGPDFPageRef page;

@end
