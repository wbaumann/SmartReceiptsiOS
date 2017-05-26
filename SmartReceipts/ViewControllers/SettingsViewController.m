//
//  SettingsViewController.m
//  SmartReceipts
//
//  Created on 13/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "SettingsViewController.h"
#import "WBColumnsViewController.h"

#import "WBPreferences.h"
#import "WBDateFormatter.h"
#import "WBCustomization.h"
#import "SettingsTopTitledTextEntryCell.h"
#import "UIView+LoadHelpers.h"
#import "UITableViewCell+Identifier.h"
#import "InputCellsSection.h"
#import "InlinedPickerCell.h"
#import "PickerCell.h"
#import "SettingsSegmentControlCell.h"
#import "SwitchControlCell.h"
#import "SettingsButtonCell.h"
#import "UIAlertView+Blocks.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Pickable.h"
#import "StringPickableWrapper.h"
#import "PendingHUDView.h"
#import "Constants.h"
#import "DataExport.h"
#import "WBFileManager.h"
#import "DecimalFormatter.h"
#import "PurchaseCell.h"
#import "Database.h"
#import "Database+Purchases.h"
#import "NSString+Validation.h"
#import "RMStore.h"
#import "SmartReceipts-Swift.h"
#import "UIDevice+DeviceInfo.h"
#import "UIApplication+AppVersion.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static NSString *const PushManageCategoriesSegueIdentifier = @"PushManageCategoriesSegueIdentifier";
static NSString *const PushConfigurePDFColumnsSegueIdentifier = @"ConfigurePDF";
static NSString *const PushConfigureCSVColumnsSegueIdentifier = @"ConfigureCSV";
static NSString *const PushPaymentMethodsControllerSegueIdentifier = @"PushPaymentMethodsControllerSegueIdentifier";

@interface SettingsViewController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *cameraValues;

@property (nonatomic, strong) PurchaseCell *removeAdsCell;
@property (nonatomic, strong) SettingsButtonCell *resporePurchaseCell;

@property (nonatomic, strong) SettingsTopTitledTextEntryCell *pdfFooterCell;

@property (nonatomic, strong) SwitchControlCell *enableAutocompleteCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *defaultTripLengthCell;
@property (nonatomic, strong) SwitchControlCell *receiptOutsideTripBoundsCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *minReportablePriceCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *userIdCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *fullNameCell;
@property (nonatomic, strong) PickerCell *defaultCurrencyCell;
@property (nonatomic, strong) InlinedPickerCell *defaultCurrencyPickerCell;
@property (nonatomic, strong) SettingsSegmentControlCell *dateSeparatorCell;
@property (nonatomic, strong) SwitchControlCell *costCenterCell;
@property (nonatomic, strong) SwitchControlCell *predictReceiptCategoriesCell;
@property (nonatomic, strong) SwitchControlCell *includeTaxFieldCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *defaultTaxPercentageCell;
@property (nonatomic, strong) SwitchControlCell *enteredPricePreTaxCell;
@property (nonatomic, strong) SwitchControlCell *assumeFullPageCell;
@property (nonatomic, strong) SwitchControlCell *matchNameToCategoriesCell;
@property (nonatomic, strong) SwitchControlCell *matchCommentsToCategoriesCell;
@property (nonatomic, strong) SwitchControlCell *onlyReportReimbursableCell;
@property (nonatomic, strong) SwitchControlCell *defaultReceiptDateToReportStartCell;
@property (nonatomic, strong) SwitchControlCell *showReceiptIDCell;
@property (nonatomic, strong) SwitchControlCell *usePaymentMethodsCell;
@property (nonatomic, strong) SettingsButtonCell *customizePaymentMethodsCell;

@property (nonatomic, strong) SettingsSegmentControlCell *cameraSettingsCell;
@property (nonatomic, strong) SwitchControlCell *cameraImageBWCell;
@property (nonatomic, strong) SwitchControlCell *cameraImageRotateCell;

@property (nonatomic, strong) SettingsButtonCell *manageCategoriesCell;

@property (nonatomic, strong) SwitchControlCell *includeCSVHeadersCell;
@property (nonatomic, strong) SettingsButtonCell *configureCSVColumnsCell;

@property (nonatomic, strong) SwitchControlCell *printReceiptIDByPhotoCell;
@property (nonatomic, strong) SwitchControlCell *printReceiptCommentByPhotoCell;
@property (nonatomic, strong) SwitchControlCell *printReceiptsTableLandscapeCell;
@property (nonatomic, strong) SettingsButtonCell *configurePDFColumnsCell;

@property (nonatomic, strong) SettingsTopTitledTextEntryCell *defaultEmailRecipientCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *defaultEmailCCCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *defaultEmailBCCCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *defaultEmailSubjectCell;

@property (nonatomic, strong) SwitchControlCell *addDistancePriceToReportCell;
@property (nonatomic, strong) SettingsTopTitledTextEntryCell *gasRateCell;
@property (nonatomic, strong) SwitchControlCell *includeDistanceTableCell;
@property (nonatomic, strong) SwitchControlCell *reportOnDailyDistanceCell;

@property (nonatomic, strong) SwitchControlCell *layoutShowReceiptDateCell;
@property (nonatomic, strong) SwitchControlCell *layoutShowReceiptCategoryCell;
@property (nonatomic, strong) SwitchControlCell *layoutShowReceiptAttachmentCell;

@property (nonatomic, strong) SettingsButtonCell *backupCell;

@property (nonatomic, strong) SettingsButtonCell *sendLoveCell;
@property (nonatomic, strong) SettingsButtonCell *sendFeedbackCell;
@property (nonatomic, strong) SettingsButtonCell *sendBugReportCell;

@property (nonatomic, assign) BOOL hasBeenShown;

@property (nonatomic, assign) BOOL hadPriceRetrieveError;
@property (nonatomic, strong) SKProduct *removeAdsProduct;

@end

@implementation SettingsViewController

#pragma mark - VC Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setContainNextEditSearchInsideSection:YES];
    
    self.navigationItem.title = NSLocalizedString(@"settings.controller.title", nil);

    [self.tableView registerNib:[SettingsTopTitledTextEntryCell viewNib] forCellReuseIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[PickerCell viewNib] forCellReuseIdentifier:[PickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedPickerCell viewNib] forCellReuseIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.tableView registerNib:[SettingsSegmentControlCell viewNib] forCellReuseIdentifier:[SettingsSegmentControlCell cellIdentifier]];
    [self.tableView registerNib:[SwitchControlCell viewNib] forCellReuseIdentifier:[SwitchControlCell cellIdentifier]];
    [self.tableView registerNib:[SettingsButtonCell viewNib] forCellReuseIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.tableView registerNib:[PurchaseCell viewNib] forCellReuseIdentifier:[PurchaseCell cellIdentifier]];


    self.removeAdsCell = [self.tableView dequeueReusableCellWithIdentifier:[PurchaseCell cellIdentifier]];
    [self.removeAdsCell setTitle:NSLocalizedString(@"settings.purchase.pro.label", nil)];

    self.resporePurchaseCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.resporePurchaseCell setTitle:NSLocalizedString(@"settings.purchase.restore.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.purchase.section.title", nil) cells:@[
            self.removeAdsCell,
            self.resporePurchaseCell
    ]]];
    
    self.pdfFooterCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.pdfFooterCell setTitle:NSLocalizedString(@"settings.pdf.footer.text.label", nil)];
    [self.pdfFooterCell.entryField setEnabled:[[Database sharedInstance] hasValidSubscription]];
    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.pro.section.title", nil) cells:@[self.pdfFooterCell]]];

    self.defaultEmailRecipientCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.defaultEmailRecipientCell setTitle:NSLocalizedString(@"settings.default.email.recipient.lebel", nil)];
    [self.defaultEmailRecipientCell setPlaceholder:NSLocalizedString(@"settings.default.email.recipient.placeholder", nil)];
    [self.defaultEmailRecipientCell activateEmailMode];

    self.defaultEmailCCCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.defaultEmailCCCell setTitle:NSLocalizedString(@"settings.default.email.cc.lebel", nil)];
    [self.defaultEmailCCCell setPlaceholder:NSLocalizedString(@"settings.default.email.cc.placeholder", nil)];
    [self.defaultEmailCCCell activateEmailMode];

    self.defaultEmailBCCCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.defaultEmailBCCCell setTitle:NSLocalizedString(@"settings.default.email.bcc.label", nil)];
    [self.defaultEmailBCCCell setPlaceholder:NSLocalizedString(@"settings.default.email.bcc.placeholder", nil)];
    [self.defaultEmailBCCCell activateEmailMode];

    self.defaultEmailSubjectCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.defaultEmailSubjectCell setTitle:NSLocalizedString(@"settings.default.email.subject.label", nil)];
    [self.defaultEmailSubjectCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.email.section.title", nil) cells:@[
            self.defaultEmailRecipientCell,
            self.defaultEmailCCCell,
            self.defaultEmailBCCCell,
            self.defaultEmailSubjectCell
    ]]];

    self.defaultTripLengthCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.defaultTripLengthCell setTitle:NSLocalizedString(@"settings.default.trip.length.label", nil)];
    [self.defaultTripLengthCell activateNumberEntryMode];

    self.enableAutocompleteCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.enableAutocompleteCell setTitle:NSLocalizedString(@"settings.enable.autocomplete.label", nil)];
    
    self.receiptOutsideTripBoundsCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.receiptOutsideTripBoundsCell setTitle:NSLocalizedString(@"settings.allow.data.outside.trip.bounds.label", nil)];

    self.minReportablePriceCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.minReportablePriceCell setTitle:NSLocalizedString(@"settings.min.receipt.price.label", nil)];
    [self.minReportablePriceCell activateDecimalEntryMode];

    self.userIdCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.userIdCell setTitle:NSLocalizedString(@"settings.user.id.label", nil)];
    
    self.fullNameCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.fullNameCell setTitle:NSLocalizedString(@"settings.name.label", nil)];

    self.defaultCurrencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.defaultCurrencyCell setTitle:NSLocalizedString(@"settings.default.currency.label", nil)];


    __weak SettingsViewController *weakSelf = self;

    self.defaultCurrencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    NSArray *cachedCurrencyCodes = [[RecentCurrenciesCache shared] cachedCurrencyCodes];
    [self.defaultCurrencyPickerCell setAllValues:[cachedCurrencyCodes arrayByAddingObjectsFromArray:[Currency allCurrencyCodes]]];
    [self.defaultCurrencyPickerCell setValueChangeHandler:^(id<Pickable> selected) {
        [weakSelf.defaultCurrencyCell setValue:selected.presentedValue];
    }];

    self.dateSeparatorCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsSegmentControlCell cellIdentifier]];
    [self.dateSeparatorCell setTitle:NSLocalizedString(@"settings.date.separator.label", nil)];

    self.costCenterCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.costCenterCell setTitle:NSLocalizedString(@"settings.track.cost.center.label", nil)];

    self.predictReceiptCategoriesCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.predictReceiptCategoriesCell setTitle:NSLocalizedString(@"settings.predict.recept.category.label", nil)];

    self.includeTaxFieldCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.includeTaxFieldCell setTitle:NSLocalizedString(@"settings.include.tax.field.label", nil)];

    self.defaultTaxPercentageCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.defaultTaxPercentageCell setTitle:NSLocalizedString(@"settings.default.tax.percentage", nil)];
    [self.defaultTaxPercentageCell activateDecimalEntryMode];

    self.enteredPricePreTaxCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.enteredPricePreTaxCell setTitle:NSLocalizedString(@"settings.assume.price.pre.tax.label", nil)];
    
    self.assumeFullPageCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.assumeFullPageCell setTitle:NSLocalizedString(@"settings.receipt.assume.full.page.image.label", nil)];

    self.matchNameToCategoriesCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.matchNameToCategoriesCell setTitle:NSLocalizedString(@"settings.match.name.to.category.label", nil)];

    self.matchCommentsToCategoriesCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.matchCommentsToCategoriesCell setTitle:NSLocalizedString(@"settings.match.comments.to.categories", nil)];

    self.onlyReportReimbursableCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.onlyReportReimbursableCell setTitle:NSLocalizedString(@"settings.only.report.reimbursable.label", nil)];

    self.defaultReceiptDateToReportStartCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.defaultReceiptDateToReportStartCell setTitle:NSLocalizedString(@"settings.default.receipt.date.to.start.date.label", nil)];

    self.showReceiptIDCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.showReceiptIDCell setTitle:NSLocalizedString(@"settings.show.receipt.id.label", nil)];

    self.usePaymentMethodsCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.usePaymentMethodsCell setTitle:NSLocalizedString(@"settings.enable.payment.methods.label", nil)];

    self.customizePaymentMethodsCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.customizePaymentMethodsCell setTitle:NSLocalizedString(@"settings.customize.payment.methods.label", nil)];

    InputCellsSection *general = [InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.general.section.title", nil)
                                                               cells:@[self.enableAutocompleteCell,
                                                                       self.defaultTripLengthCell,
                                                                       self.receiptOutsideTripBoundsCell,
                                                                       self.minReportablePriceCell,
                                                                       self.userIdCell,
                                                                       self.fullNameCell,
                                                                       self.defaultCurrencyCell,
                                                                       self.dateSeparatorCell,
                                                                       self.costCenterCell,
                                                                       self.predictReceiptCategoriesCell,
                                                                       self.includeTaxFieldCell,
                                                                       self.defaultTaxPercentageCell,
                                                                       self.enteredPricePreTaxCell,
                                                                       self.assumeFullPageCell,
                                                                       self.matchNameToCategoriesCell,
                                                                       self.matchCommentsToCategoriesCell,
                                                                       self.onlyReportReimbursableCell,
                                                                       self.defaultReceiptDateToReportStartCell,
                                                                       self.showReceiptIDCell,
                                                                       self.usePaymentMethodsCell,
                                                                       self.customizePaymentMethodsCell]];
    [self addSectionForPresentation:general];

    [self addInlinedPickerCell:self.defaultCurrencyPickerCell forCell:self.defaultCurrencyCell];

    self.cameraSettingsCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsSegmentControlCell cellIdentifier]];
    [self.cameraSettingsCell setTitle:NSLocalizedString(@"settings.max.camera.resolution.label", nil)];

    self.cameraImageBWCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.cameraImageBWCell setTitle:NSLocalizedString(@"settings.convert.to.grayscale.label", nil)];

    self.cameraImageRotateCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.cameraImageRotateCell setTitle:NSLocalizedString(@"settings.automatically.rotate.images.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.camera.section.title", nil) cells:@[
            self.cameraSettingsCell,
            self.cameraImageBWCell,
            //self.cameraImageRotateCell
    ]]];

    self.manageCategoriesCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.manageCategoriesCell setTitle:NSLocalizedString(@"settings.manage.categories.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.categories.section.title", nil) cells:@[self.manageCategoriesCell]]];

    self.includeCSVHeadersCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.includeCSVHeadersCell setTitle:NSLocalizedString(@"settings.csv.include.header.columns.label", nil)];

    self.configureCSVColumnsCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.configureCSVColumnsCell setTitle:NSLocalizedString(@"settings.csv.configure.columns.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.csv.section.title", nil) cells:@[self.includeCSVHeadersCell, self.configureCSVColumnsCell]]];

    self.printReceiptIDByPhotoCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.printReceiptIDByPhotoCell setTitle:NSLocalizedString(@"settings.pdf.print.id.by.photo.label", nil)];

    self.printReceiptCommentByPhotoCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.printReceiptCommentByPhotoCell setTitle:NSLocalizedString(@"settings.pdf.print.receipt.comment.by.photo.label", nil)];
    
    self.printReceiptsTableLandscapeCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.printReceiptsTableLandscapeCell setTitle:NSLocalizedString(@"settings.pdf.print.receipt.table.landscape.label", nil)];

    self.configurePDFColumnsCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.configurePDFColumnsCell setTitle:NSLocalizedString(@"settings.pdf.configure.columns.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.pdf.section.title", nil) cells:@[
            self.printReceiptIDByPhotoCell,
            self.printReceiptCommentByPhotoCell,
            self.printReceiptsTableLandscapeCell,
            self.configurePDFColumnsCell]]];

    self.addDistancePriceToReportCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.addDistancePriceToReportCell setTitle:NSLocalizedString(@"settings.add.distance.price.to.report.label", nil)];


    self.gasRateCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsTopTitledTextEntryCell cellIdentifier]];
    [self.gasRateCell setTitle:NSLocalizedString(@"settings.gas.rate.label", nil)];
    [self.gasRateCell activateDecimalEntryModeWithDecimalPlaces:SmartReceiptsNumberOfDecimalPlacesForGasRate];

    self.includeDistanceTableCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.includeDistanceTableCell setTitle:NSLocalizedString(@"settings.include.distance.table.label", nil)];

    self.reportOnDailyDistanceCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.reportOnDailyDistanceCell setTitle:NSLocalizedString(@"settings.distance.report.on.daily.distance", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.distance.section.title", nil)
                                                                  cells:@[self.addDistancePriceToReportCell,
                                                                          self.gasRateCell,
                                                                          self.includeDistanceTableCell,
                                                                          self.reportOnDailyDistanceCell]]];

    self.layoutShowReceiptDateCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.layoutShowReceiptDateCell setTitle:NSLocalizedString(@"settings.layout.include.receipt.date.label", nil)];

    self.layoutShowReceiptCategoryCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.layoutShowReceiptCategoryCell setTitle:NSLocalizedString(@"settings.layout.include.receipt.category.label", nil)];

    self.layoutShowReceiptAttachmentCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.layoutShowReceiptAttachmentCell setTitle:NSLocalizedString(@"settings.layout.include.attachment.marker.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.layout.section.title", nil) cells:@[
            self.layoutShowReceiptDateCell,
            self.layoutShowReceiptCategoryCell,
            self.layoutShowReceiptAttachmentCell
    ]]];


    self.backupCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.backupCell setTitle:NSLocalizedString(@"settings.backup.button.label", nil)];

    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.backup.section.title", nil) cells:@[self.backupCell]]];
    
    // Feedback settings:
    self.sendLoveCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.sendLoveCell setTitle:NSLocalizedString(@"settings.feedback.sendLove.label", nil)];
    
    self.sendFeedbackCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.sendFeedbackCell setTitle:NSLocalizedString(@"settings.feedback.sendFeedback.label", nil)];
    
    self.sendBugReportCell = [self.tableView dequeueReusableCellWithIdentifier:[SettingsButtonCell cellIdentifier]];
    [self.sendBugReportCell setTitle:NSLocalizedString(@"settings.feedback.sendBugReport.label", nil)];
    
    [self addSectionForPresentation:[InputCellsSection sectionWithTitle:NSLocalizedString(@"settings.feedback.section.label", nil) cells: @[
                                                                                                                                            self.sendLoveCell,
                                                                                                                                            self.sendFeedbackCell,
                                                                                                                                            self.sendBugReportCell
                                                                                                                                            ]]];
    

    [self.navigationController setToolbarHidden:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateValues) name:SmartReceiptsPreferencesImportedNotification object:nil];
}

- (void)populateValues {
    [self.pdfFooterCell setValue:[WBPreferences pdfFooterString]];
    
    [self.defaultEmailRecipientCell setValue:[WBPreferences defaultEmailRecipient]];
    [self.defaultEmailCCCell setValue:[WBPreferences defaultEmailCC]];
    [self.defaultEmailBCCCell setValue:[WBPreferences defaultEmailBCC]];
    [self.defaultEmailSubjectCell setValue:[WBPreferences defaultEmailSubject]];

    [self.enableAutocompleteCell setSwitchOn:[WBPreferences isAutocompleteEnabled]];
    [self.defaultTripLengthCell setValue:[NSString stringWithFormat:@"%d",[WBPreferences defaultTripDuration]]];
    [self.receiptOutsideTripBoundsCell setSwitchOn:[WBPreferences allowDataEntryOutsideTripBounds]];

    float minimumPrice = [WBPreferences minimumReceiptPriceToIncludeInReports];
    if (minimumPrice <= 0) {
        // If "minimumPrice" is less than or equal to 0, it means means "INCLUDE_ALL" and will be blanked out in the field
        [self.minReportablePriceCell setValue:@""];
    } else {
        [self.minReportablePriceCell setValue:[NSString stringWithFormat:@"%d", (int) minimumPrice]];
    }

    [self.userIdCell setValue:[WBPreferences userID]];
    [self.fullNameCell setValue:[WBPreferences fullName]];
    [self.defaultCurrencyCell setValue:[WBPreferences defaultCurrency]];
    [self.defaultCurrencyPickerCell setSelectedValue:[StringPickableWrapper wrapValue:[WBPreferences defaultCurrency]]];
    [self.predictReceiptCategoriesCell setSwitchOn:[WBPreferences predictCategories]];
    [self.includeTaxFieldCell setSwitchOn:[WBPreferences includeTaxField]];
    float defaultTax = [WBPreferences defaultTaxPercentage];
    if (defaultTax < 0.001) {
        [self.defaultTaxPercentageCell setValue:@""];
    } else {
        NSDecimalNumber *taxPercentage = (NSDecimalNumber *) [[NSDecimalNumber alloc] initWithFloat:defaultTax];
        [self.defaultTaxPercentageCell setValue:[taxPercentage descriptionWithLocale:[NSLocale currentLocale]]];
    }
    [self.enteredPricePreTaxCell setSwitchOn:[WBPreferences enteredPricePreTax]];
    [self.assumeFullPageCell setSwitchOn:[WBPreferences assumeFullPage]];
    [self.matchNameToCategoriesCell setSwitchOn:[WBPreferences matchNameToCategory]];
    [self.matchCommentsToCategoriesCell setSwitchOn:[WBPreferences matchCommentToCategory]];
    [self.onlyReportReimbursableCell setSwitchOn:[WBPreferences onlyIncludeReimbursableReceiptsInReports]];
    [self.defaultReceiptDateToReportStartCell setSwitchOn:[WBPreferences defaultToFirstReportDate]];
    [self.showReceiptIDCell setSwitchOn:[WBPreferences showReceiptID]];
    [self.usePaymentMethodsCell setSwitchOn:[WBPreferences usePaymentMethods]];

    NSArray *separators = @[@"-", @"/", @"."];
    NSString *systemSeparator = [[[WBDateFormatter alloc] init] separatorForCurrentLocale];
    if ([separators indexOfObject:systemSeparator] == NSNotFound) {
        separators = [separators arrayByAddingObject:systemSeparator];
    }

    NSUInteger idx = [separators indexOfObject:[WBPreferences dateSeparator]];
    if (idx == NSNotFound) {
        idx = 1;
    }
    [self.dateSeparatorCell setValues:separators selected:idx];

    [self.costCenterCell setSwitchOn:[WBPreferences trackCostCenter]];

    self.cameraValues = @[@512, @1024, @0];

    NSMutableArray *presentedCameraValues = [NSMutableArray array];
    NSUInteger selectedCameraValueIndex = 1;
    for (NSUInteger index = 0; index < self.cameraValues.count; index++) {
        int val = [((NSNumber*) self.cameraValues[index]) intValue];
        if (val == 0) {
            [presentedCameraValues addObject:NSLocalizedString(@"settings.camera.value.default.label", nil)];
        } else {
            [presentedCameraValues addObject:[NSString stringWithFormat:@"%d %@", val, NSLocalizedString(@"settings.camera.pixels.label", nil)]];
        }

        if (val == [WBPreferences cameraMaxHeightWidth]) {
            selectedCameraValueIndex = index;
        }
    }
    [self.cameraSettingsCell setValues:presentedCameraValues selected:selectedCameraValueIndex];
    [self.cameraImageBWCell setSwitchOn:[WBPreferences cameraSaveImagesBlackAndWhite]];
    [self.cameraImageRotateCell setSwitchOn:[WBPreferences cameraRotateImage]];

    [self.includeCSVHeadersCell setSwitchOn:[WBPreferences includeCSVHeaders]];

    [self.printReceiptIDByPhotoCell setSwitchOn:[WBPreferences printReceiptIDByPhoto]];
    [self.printReceiptCommentByPhotoCell setSwitchOn:[WBPreferences printCommentByPhoto]];
    [self.printReceiptsTableLandscapeCell setSwitchOn:[WBPreferences printReceiptTableLandscape]];

    [self.addDistancePriceToReportCell setSwitchOn:[WBPreferences isTheDistancePriceBeIncludedInReports]];
    double defaultValue = [WBPreferences distanceRateDefaultValue];
    if (defaultValue < 0.0001) {
        [self.gasRateCell setValue:@""];
    } else {
        [self.gasRateCell setValue:[DecimalFormatter formatDouble:defaultValue decimalPlaces:SmartReceiptsNumberOfDecimalPlacesForGasRate]];
    }
    [self.includeDistanceTableCell setSwitchOn:[WBPreferences printDistanceTable]];
    [self.reportOnDailyDistanceCell setSwitchOn:[WBPreferences printDailyDistanceValues]];

    [self.layoutShowReceiptDateCell setSwitchOn:[WBPreferences layoutShowReceiptDate]];
    [self.layoutShowReceiptCategoryCell setSwitchOn:[WBPreferences layoutShowReceiptCategory]];
    [self.layoutShowReceiptAttachmentCell setSwitchOn:[WBPreferences layoutShowReceiptAttachmentMarker]];
}

- (void)writeSettingsToPreferences {
    NSString *daysStr = self.defaultTripLengthCell.value;
    if ([daysStr length] > 0 && [daysStr length] < 4) {
        [WBPreferences setDefaultTripDuration:[daysStr intValue]];
    }

    [WBPreferences setAutocompleteEnabled:self.enableAutocompleteCell.isSwitchOn];
    [WBPreferences setAllowDataEntryOutsideTripBounds:self.receiptOutsideTripBoundsCell.isSwitchOn];

    NSString *priceStr = [self.minReportablePriceCell value];
    if (priceStr.length > 0) {
        // parse string for float number and remember
        float minPriceToReport = priceStr.floatValue;
        [WBPreferences setMinimumReceiptPriceToIncludeInReports:minPriceToReport];
    } else {
        // empty field, persist MIN_FLOAT
        [WBPreferences setMinimumReceiptPriceToIncludeInReports:[WBPreferences MIN_FLOAT]];
    }
    
    [WBPreferences setPDFFooterString:self.pdfFooterCell.value];

    [WBPreferences setDefaultEmailRecipient:self.defaultEmailRecipientCell.value];
    [WBPreferences setDefaultEmailCC:self.defaultEmailCCCell.value];
    [WBPreferences setDefaultEmailBCC:self.defaultEmailBCCCell.value];
    [WBPreferences setDefaultEmailSubject:self.defaultEmailSubjectCell.value];
    [WBPreferences setUserID:self.userIdCell.value];
    [WBPreferences setFullName:self.fullNameCell.value];
    [WBPreferences setDefaultCurrency:[self.defaultCurrencyCell value]];
    [WBPreferences setDateSeparator:[self.dateSeparatorCell selectedValue]];
    [WBPreferences setTrackCostCenter:[self.costCenterCell isSwitchOn]];

    NSNumber *cam = self.cameraValues[(NSUInteger) [self.cameraSettingsCell selectedSegmentIndex]];
    [WBPreferences setCameraMaxHeightWidth:[cam intValue]];
    [WBPreferences setCameraSaveImagesBlackAndWhite:self.cameraImageBWCell.isSwitchOn];
    [WBPreferences setCameraRotateImage:self.cameraImageRotateCell.isSwitchOn];

    [WBPreferences setPredictCategories:[self.predictReceiptCategoriesCell isSwitchOn]];
    [WBPreferences setIncludeTaxField:self.includeTaxFieldCell.isSwitchOn];
    NSString *tax = [self.defaultTaxPercentageCell value];
    NSDecimalNumber *taxNumber = [NSDecimalNumber decimalNumberOrZero:tax];
    [WBPreferences setDefaultTaxPercentage:taxNumber.floatValue];
    [WBPreferences setEnteredPricePreTax:self.enteredPricePreTaxCell.isSwitchOn];
    [WBPreferences setAssumeFullPage:self.assumeFullPageCell.isSwitchOn];
    [WBPreferences setMatchNameToCategory:self.matchNameToCategoriesCell.isSwitchOn];
    [WBPreferences setMatchCommentToCategory:self.matchCommentsToCategoriesCell.isSwitchOn];
    [WBPreferences setOnlyIncludeReimbursableReceiptsInReports:self.onlyReportReimbursableCell.isSwitchOn];
    [WBPreferences setDefaultToFirstReportDate:self.defaultReceiptDateToReportStartCell.isSwitchOn];
    [WBPreferences setShowReceiptID:self.showReceiptIDCell.isSwitchOn];
    [WBPreferences setUsePaymentMethods:self.usePaymentMethodsCell.isSwitchOn];

    [WBPreferences setIncludeCSVHeaders:self.includeCSVHeadersCell.isSwitchOn];

    [WBPreferences setPrintReceiptIDByPhoto:self.printReceiptIDByPhotoCell.isSwitchOn];
    [WBPreferences setPrintCommentByPhoto:self.printReceiptCommentByPhotoCell.isSwitchOn];
    [WBPreferences setPrintReceiptTableLandscape:self.printReceiptsTableLandscapeCell.isSwitchOn];

    [WBPreferences setTheDistancePriceBeIncludedInReports:self.addDistancePriceToReportCell.isSwitchOn];
    NSString *gasRate = [self.gasRateCell value];
    NSDecimalNumber *rate = [NSDecimalNumber decimalNumberOrZero:gasRate];
    [WBPreferences setDistanceRateDefaultValue:[rate doubleValue]];
    [WBPreferences setPrintDistanceTable:[self.includeDistanceTableCell isSwitchOn]];
    [WBPreferences setPrintDailyDistanceValues:[self.reportOnDailyDistanceCell isSwitchOn]];

    [WBPreferences setLayoutShowReceiptDate:[self.layoutShowReceiptDateCell isSwitchOn]];
    [WBPreferences setLayoutShowReceiptCategory:[self.layoutShowReceiptCategoryCell isSwitchOn]];
    [WBPreferences setLayoutShowReceiptAttachmentMarker:[self.layoutShowReceiptAttachmentCell isSwitchOn]];

    [WBPreferences save];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];

    [self updatePurchaseStatus];

    if (!self.removeAdsProduct && !self.hadPriceRetrieveError) {
        [self retrievePurchasePrices];
    }

    if (self.hasBeenShown) {
        return;
    }

    [self populateValues];
    [self setHasBeenShown:YES];
    
    [self analyticsSettingsOverflow];
    
    if (_wasPresentedFromGeneratorVC) {
        NSIndexPath *outputSection = [NSIndexPath indexPathForRow:0 inSection:6];
        [self.tableView scrollToRowAtIndexPath:outputSection atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] hasPrefix:@"Configure"]) {
        WBColumnsViewController *vc = (WBColumnsViewController *) [segue destinationViewController];
        vc.forCSV = [[segue identifier] isEqualToString:@"ConfigureCSV"];
    }
}

- (void)actionExport {
    // record analytics event:
    [self analyticsBackupOverflow];
    
    void (^exportActionBlock)() = ^{
        PendingHUDView *hud = [PendingHUDView showHUDOnView:self.navigationController.view];
        TICK;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DataExport *export = [[DataExport alloc] initWithWorkDirectory:[WBFileManager documentsPath]];
            NSString *exportPath = [export execute];
            BOOL isFileExists = [[NSFileManager defaultManager] fileExistsAtPath:exportPath];
            LOGGER_INFO(@"actionExport finished: time %@, exportPath: %@", TOCK, exportPath);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                
                if (isFileExists) {
                    [self shareBackupFile:exportPath fromRect:[self.tableView convertRect:self.backupCell.frame toView:self.view]];
                } else {
                    LOGGER_ERROR(@"Failed to properly export data");
                    [[[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@"generic.error.alert.title", nil)
                                  message:NSLocalizedString(@"settings.controller.export.error.message", nil)
                                 delegate:nil
                        cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil)
                        otherButtonTitles:nil] show];
                }
            });
        });
    };

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"settings.export.confirmation.alert.title", nil)
                                                        message:NSLocalizedString(@"settings.export.confirmation.alert.message", nil)
                                               cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.cancel", nil)]
                                               otherButtonItems:[RIButtonItem itemWithLabel:NSLocalizedString(@"settings.export.confirmation.export.button", nil) action:exportActionBlock], nil];

    [alertView show];
}

- (IBAction)actionDone:(id)sender {
    [self writeSettingsToPreferences];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsSettingsSavedNotification object:nil];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tappedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (cell == self.manageCategoriesCell) {
        [self performSegueWithIdentifier:PushManageCategoriesSegueIdentifier sender:nil];
    } else if (cell == self.configureCSVColumnsCell) {
        [self performSegueWithIdentifier:PushConfigureCSVColumnsSegueIdentifier sender:nil];
    } else if (cell == self.configurePDFColumnsCell) {
        [self performSegueWithIdentifier:PushConfigurePDFColumnsSegueIdentifier sender:nil];
    } else if (cell == self.backupCell) {
        [self actionExport];
    } else if (cell == self.customizePaymentMethodsCell) {
        [self performSegueWithIdentifier:PushPaymentMethodsControllerSegueIdentifier sender:nil];
    } else if (cell == self.resporePurchaseCell) {
        [self restorePurchases];
    } else if (cell == self.removeAdsCell && ![[Database sharedInstance] hasValidSubscription]) {
        [self makePurchase:self.removeAdsProduct];
    } else if (cell == self.pdfFooterCell) {
        [self showAlertWithTitle:NSLocalizedString(@"settings.pdf.footer.pro.message.title", nil) message:NSLocalizedString(@"settings.pdf.footer.pro.message.body", nil)];
    } else if (cell == self.sendLoveCell) {
        [self sendLove];
    } else if (cell == self.sendFeedbackCell) {
        [self emailFeedbackWithSubject:FeedbackEmailSubject];
    } else if (cell == self.sendBugReportCell) {
        [self emailFeedbackWithSubject:FeedbackBugreportEmailSubject];
    }
}

- (void)updatePurchaseStatus {
    [self.removeAdsCell setSubscriptionEndDate:[[Database sharedInstance] subscriptionEndDate]];
    if ([[Database sharedInstance] hasValidSubscription]) {
        [self.removeAdsCell markPurchased];
    } else if (self.hadPriceRetrieveError) {
        [self.removeAdsCell markErrorWithTapHandler:^{
            [self showAlertWithTitle:NSLocalizedString(@"settings.purchase.price.retrieve.error.title", nil)
                             message:NSLocalizedString(@"settings.purchase.price.retrieve.error.message", nil)];
        }];
    } else if (!self.removeAdsProduct) {
        [self.removeAdsCell markSpinning];
    }
}

- (void)retrievePurchasePrices {
    [[RMStore defaultStore] requestProducts:[NSSet setWithObject:SmartReceiptSubscriptionIAPIdentifier] success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

        for (SKProduct *product in products) {
            if ([product.productIdentifier isEqualToString:SmartReceiptSubscriptionIAPIdentifier]) {
                [self setRemoveAdsProduct:product];
                [numberFormatter setLocale:product.priceLocale];
                NSString *formattedPrice = [NSString stringWithFormat:@"%@/yr", [numberFormatter stringFromNumber:product.price]];
                [self.removeAdsCell setPriceString:formattedPrice];
            }
        }
    } failure:^(NSError *error) {
        ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:error
                                                              file:NSStringFromClass([self class])
                                                          function:NSStringFromSelector(_cmd)
                                                              line:__LINE__];
        [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        [self setHadPriceRetrieveError:YES];
        [self updatePurchaseStatus];
    }];
}

- (void)restorePurchases {
    PendingHUDView *hud = [PendingHUDView showHUDOnView:self.navigationController.view];

    [[RMStore defaultStore] refreshReceiptOnSuccess:^{
        [hud hide];
        [self updatePurchaseStatus];
        [self.pdfFooterCell.entryField setEnabled:[[Database sharedInstance] hasValidSubscription]];
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsAdsRemovedNotification object:nil];
    } failure:^(NSError *error) {
        [hud hide];
        
        if (error.code == SKErrorPaymentCancelled && [error.domain isEqualToString:SKErrorDomain]) {
            // was cancelled by the user
            return;
        } else {
            // Unknown error:
            ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:error
                                                                  file:NSStringFromClass([self class])
                                                              function:NSStringFromSelector(_cmd)
                                                                  line:__LINE__];
            [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        }

        [self showAlertWithTitle:NSLocalizedString(@"settings.purchase.restore.error.title", nil)
                         message:error.localizedDescription];
    }];
}

- (void)makePurchase:(SKProduct *)product {
    // record analytics event:
    [self analyticsSmartReceiptsPlusOverflow];
    
    PendingHUDView *hud = [PendingHUDView showHUDOnView:self.navigationController.view];
    [[RMStore defaultStore] addPayment:product.productIdentifier success:^(SKPaymentTransaction *transaction) {
        [hud hide];
        [self analyticsPurchaseSuccessWithProductID:transaction.payment.productIdentifier];
        [self updatePurchaseStatus];
        [self.pdfFooterCell.entryField setEnabled:[[Database sharedInstance] hasValidSubscription]];
        [[NSNotificationCenter defaultCenter] postNotificationName:SmartReceiptsAdsRemovedNotification object:nil];
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [hud hide];
        
        if (error.code == SKErrorPaymentCancelled && [error.domain isEqualToString:SKErrorDomain]) {
            // Payment was cancelled by the user
            return;
        } else {
            // Unknown error:
            ErrorEvent *errorEvent = [[ErrorEvent alloc] initWithError:error
                                                                  file:NSStringFromClass([self class])
                                                              function:NSStringFromSelector(_cmd)
                                                                  line:__LINE__];
            [[AnalyticsManager sharedManager] recordWithEvent:errorEvent];
        }
        
        [self analyticsPurchaseFailedWithProductID:transaction.payment.productIdentifier];

        [self showAlertWithTitle:NSLocalizedString(@"settings.purchase.make.purchase.error.title", nil)
                         message:error.localizedDescription];
    }];
}

 - (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                                otherButtonItems:nil];
     [alertView show];
 }

#pragma mark - Feedback section actions

- (void)sendLove {
    NSURL *reviewURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", SmartReceiptAppStoreId]];
    if ([[UIApplication sharedApplication] canOpenURL:reviewURL]) {
        [[UIApplication sharedApplication] openURL:reviewURL];
    }
}

#pragma mark - MFMailComposeViewController, MFMailComposeViewControllerDelegate

- (void)emailFeedbackWithSubject:(NSString *)subject {
    // Checking the availability of mail services
    if (![MFMailComposeViewController canSendMail]) {
        LOGGER_WARNING(@"Mail services are not available.");
        [self showAlertWithTitle:NSLocalizedString(@"settings.feedback.email.error", nil) message:NSLocalizedString(@"settings.feedback.email.not.configured.message", nil)];
        return;
    }
    
    MFMailComposeViewController *composeVC = [[MFMailComposeViewController alloc] init];
    composeVC.mailComposeDelegate = self;
    
    // Configure the fields of the interface.
    NSMutableString *messageBody = [NSMutableString new];
    // attach device info metadata
    [messageBody appendString:@"\n\n\nDebug info:\n"];
    [messageBody appendString:[[UIApplication sharedApplication] appVersionInfoString]];
    [messageBody appendFormat:@"Plus: %@\n", [[Database sharedInstance] hasValidSubscription] ? @"true" : @"false"];
    [messageBody appendString:[[UIDevice currentDevice] deviceInfoString]];
    
    // Attach log files
    NSArray *logFiles = [Logger logFiles];
    for (DDLogFileInfo *file in logFiles) {
        NSData *data = [NSData dataWithContentsOfFile:file.filePath];
        if (data != nil) {
            [composeVC addAttachmentData:data mimeType:@"text/plain" fileName:file.fileName];
        }
    }
    
    [composeVC setToRecipients:@[FeedbackEmailAddress]];
    [composeVC setSubject:subject];
    [composeVC setMessageBody:messageBody isHTML:NO];
    composeVC.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
    
    UIStatusBarStyle style = [UIApplication sharedApplication].statusBarStyle;
    [self presentViewController:composeVC animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:style animated:NO];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Check the result or perform other tasks.
    if (result == MFMailComposeResultFailed) {
        LOGGER_WARNING(@"MFMailComposeResultFailed: %@", error.localizedDescription);
        [self showAlertWithTitle:NSLocalizedString(@"settings.feedback.email.error", nil) message:error.localizedDescription];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
