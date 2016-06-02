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
@class ExchangeRateCell;

NS_ASSUME_NONNULL_BEGIN

@interface EditReceiptViewController : InputCellsViewController

@property (weak, nonatomic) WBReceiptsViewController *receiptsViewController;
@property (nonatomic, strong) UIImage *receiptImage;

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip *)trip;

@end


@interface EditReceiptViewController (ExposeForSwiftExtension)

@property (nonatomic, strong, readonly) ExchangeRateCell *exchangeRateCell;

- (NSString *)tripCurrency;
- (NSString *)receiptCurrency;
- (NSDate *)receiptDate;

@end

NS_ASSUME_NONNULL_END