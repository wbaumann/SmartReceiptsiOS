//
//  FullPagePDFPageView.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 14/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDFPageRenderView;

@interface FullPagePDFPageView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) PDFPageRenderView *pageRenderView;

@end
