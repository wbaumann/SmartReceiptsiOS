//
//  EditReceiptViewController.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "WBDynamicPicker.h"

#import "HTAutocompleteTextField.h"
#import "InputCellsViewController.h"

@class WBReceipt, WBTrip, EditReceiptViewController, WBReceiptsViewController;

@protocol WBNewReceiptViewControllerDelegate <NSObject>

- (void)viewController:(EditReceiptViewController *)viewController newReceipt:(WBReceipt *)receipt;
- (void)viewController:(EditReceiptViewController *)viewController updatedReceipt:(WBReceipt *)newReceipt fromReceipt:(WBReceipt *)oldReceipt;

@end

@interface EditReceiptViewController : InputCellsViewController

@property (weak, nonatomic) id <WBNewReceiptViewControllerDelegate> delegate;
@property (weak, nonatomic) WBReceiptsViewController *receiptsViewController;

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip *)trip;
- (void)setReceiptImage:(UIImage *)image;

@end
