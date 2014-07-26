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

@class WBReceipt, WBTrip, WBNewReceiptViewController, WBReceiptsViewController;

@protocol WBNewReceiptViewControllerDelegate <NSObject>

-(void) viewController:(WBNewReceiptViewController*)viewController newReceipt:(WBReceipt*) receipt;
-(void) viewController:(WBNewReceiptViewController*)viewController updatedReceipt:(WBReceipt*) newReceipt fromReceipt:(WBReceipt*) oldReceipt;

@end

@interface WBNewReceiptViewController : WBTableViewController<WBDynamicPickerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *taxTextField;

@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
@property (weak, nonatomic) IBOutlet UISwitch *expensableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fullPageImageSwitch;


@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelTax;
@property (weak, nonatomic) IBOutlet UILabel *labelCurrency;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;
@property (weak, nonatomic) IBOutlet UILabel *labelComment;
@property (weak, nonatomic) IBOutlet UILabel *labelExpensable;
@property (weak, nonatomic) IBOutlet UILabel *labelFullPageImage;



- (IBAction)currencyButtonClicked:(id)sender;
- (IBAction)dateButtonClicked:(id)sender;
- (IBAction)categoryButtonClicked:(id)sender;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionCancel:(id)sender;

@property (weak,nonatomic) id<WBNewReceiptViewControllerDelegate> delegate;
@property (weak,nonatomic) WBReceiptsViewController* receiptsViewController;

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip*) trip;
- (void)setReceiptImage:(UIImage *)image;

@end
