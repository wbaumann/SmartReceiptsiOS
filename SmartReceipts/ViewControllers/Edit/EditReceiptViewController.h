//
//  EditReceiptViewController.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDynamicPicker.h"

#import "InputCellsViewController.h"

@class WBReceipt, WBTrip, EditReceiptViewController, WBReceiptsViewController;
@class ExchangeRateCell;
@class ReceiptsView;

NS_ASSUME_NONNULL_BEGIN

@interface EditReceiptViewController : InputCellsViewController

@property (weak, nonatomic) ReceiptsView *receiptsViewController;
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
