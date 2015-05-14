//
//  WBNewReceiptViewController.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "WBDynamicPicker.h"

#import "HTAutocompleteTextField.h"
#import "InputCellsViewController.h"

@class WBReceipt, WBTrip, WBNewReceiptViewController, WBReceiptsViewController;

@protocol WBNewReceiptViewControllerDelegate <NSObject>

- (void)viewController:(WBNewReceiptViewController *)viewController newReceipt:(WBReceipt *)receipt;
- (void)viewController:(WBNewReceiptViewController *)viewController updatedReceipt:(WBReceipt *)newReceipt fromReceipt:(WBReceipt *)oldReceipt;

@end

@interface WBNewReceiptViewController : InputCellsViewController

@property (weak, nonatomic) id <WBNewReceiptViewControllerDelegate> delegate;
@property (weak, nonatomic) WBReceiptsViewController *receiptsViewController;

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip *)trip;
- (void)setReceiptImage:(UIImage *)image;

@end
