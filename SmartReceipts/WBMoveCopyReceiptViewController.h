//
//  WBMoveCopyReceiptViewController.h
//  SmartReceipts
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import "WBReceiptActionsViewController.h"
#import "WBReceiptsViewController.h"
#import "WBTripsViewController.h"

@interface WBMoveCopyReceiptViewController : WBTableViewController

@property (weak,nonatomic) WBReceiptActionsViewController* receiptActionsViewController;
@property BOOL calledForCopy;

@end
