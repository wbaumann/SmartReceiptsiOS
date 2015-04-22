//
//  WBReceiptActionsViewController.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import "WBReceiptsViewController.h"

#import "WBReceipt.h"

#import <QuickLook/QuickLook.h>

@interface WBReceiptActionsViewController : WBTableViewController<UIDocumentInteractionControllerDelegate>

@property (weak,nonatomic) WBReceiptsViewController* receiptsViewController;
@property WBReceipt* receipt;

- (IBAction)actionDone:(id)sender;

@end
