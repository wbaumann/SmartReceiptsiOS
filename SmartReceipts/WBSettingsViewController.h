//
//  WBSettingsViewController.h
//  SmartReceipts
//
//  Created on 13/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "WBDynamicPicker.h"

#import <MessageUI/MessageUI.h>

@interface WBSettingsViewController : WBTableViewController<WBDynamicPickerDelegate,UITextFieldDelegate, UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailReceiptField;
@property (weak, nonatomic) IBOutlet UITextField *tripLengthField;
@property (weak, nonatomic) IBOutlet UITextField *minimumReceiptPriceField;
@property (weak, nonatomic) IBOutlet UITextField *userIdField;

@property (weak, nonatomic) IBOutlet UIButton *defaultCurrencyButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateSeparatorField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cameraWidthHeightField;

@property (weak, nonatomic) IBOutlet UISwitch *predictReceiptCategoriesField;
@property (weak, nonatomic) IBOutlet UISwitch *includeTaxFieldForReceiptsField;
@property (weak, nonatomic) IBOutlet UISwitch *matchNameToCategoriesField;
@property (weak, nonatomic) IBOutlet UISwitch *matchCommentsToCategoriesField;
@property (weak, nonatomic) IBOutlet UISwitch *onlyReportExpensableReceiptsField;
@property (weak, nonatomic) IBOutlet UISwitch *enableAutoCompleteSuggestionsField;
@property (weak, nonatomic) IBOutlet UISwitch *defaultReceiptDateToReportStartDateField;

@property (weak, nonatomic) IBOutlet UISwitch *includeHeaderColumnsField;


@property (weak, nonatomic) IBOutlet UILabel *labelEmailReceipt;
@property (weak, nonatomic) IBOutlet UILabel *labelTripLength;
@property (weak, nonatomic) IBOutlet UILabel *labelMinimumReceiptPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelUserId;

@property (weak, nonatomic) IBOutlet UILabel *labelDefaultCurrency;
@property (weak, nonatomic) IBOutlet UILabel *labelDateSeparator;
@property (weak, nonatomic) IBOutlet UILabel *labelCameraWidthHeight;

@property (weak, nonatomic) IBOutlet UILabel *labelPredictReceiptCategories;
@property (weak, nonatomic) IBOutlet UILabel *labelIncludeTaxForReceipts;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchNameToCategories;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchCommentsToCategories;
@property (weak, nonatomic) IBOutlet UILabel *labelOnlyReportExpensableReceipts;
@property (weak, nonatomic) IBOutlet UILabel *labelEnableAutoCompleteSuggestions;
@property (weak, nonatomic) IBOutlet UILabel *labelDefaultReceiptDateToReportStartDate;

@property (weak, nonatomic) IBOutlet UILabel *labelIncludeHeaderColumns;

@property (weak, nonatomic) IBOutlet UILabel *labelManageCategories;
@property (weak, nonatomic) IBOutlet UILabel *labelConfigureCsvColumns;
@property (weak, nonatomic) IBOutlet UILabel *labelConfigurePdfColumns;
@property (weak, nonatomic) IBOutlet UILabel *labelMakeBackup;


- (IBAction)defaultCurrencyClicked:(id)sender;

- (IBAction)actionDone:(id)sender;

- (void)populateValues;

+ (WBSettingsViewController*) visibleInstance;
@end
