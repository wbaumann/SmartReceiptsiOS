//
//  WBGenerateViewController.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import <MessageUI/MessageUI.h>

#import "WBReceipt.h"
#import "WBTrip.h"

NS_ASSUME_NONNULL_BEGIN

@class ReportAssetsGenerator;

@interface WBGenerateViewController : WBTableViewController

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong, nullable) ReportAssetsGenerator *generator;
@property (nonatomic, strong, nullable) UIDocumentInteractionController *documentInteractionController;

@end

@interface WBGenerateViewController (SwiftExpose)

@property (nonatomic, readonly) UISwitch *fullPdfReportField;
@property (nonatomic, readonly) UISwitch *pdfImagesField;
@property (nonatomic, readonly) UISwitch *csvFileField;
@property (nonatomic, readonly) UISwitch *zipImagesField;

@end

NS_ASSUME_NONNULL_END