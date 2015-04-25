//
//  WBSettingsViewController.m
//  SmartReceipts
//
//  Created on 13/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBSettingsViewController.h"
#import "WBCurrency.h"
#import "WBColumnsViewController.h"
#import "WBTextUtils.h"

#import "WBPreferences.h"
#import "WBDateFormatter.h"

#import "WBBackupHelper.h"

#import "HUD.h"

// for refreshing while backup
static WBSettingsViewController *visibleInstance = nil;

@interface WBSettingsViewController () {
    WBDynamicPicker* dynamicPicker;
    
    NSArray *currencyCodes;
    NSString *currentCurrencyCode;
    int pickedRow;
    
    NSArray *cameraValues;
}

@end

@implementation WBSettingsViewController

+ (WBSettingsViewController*) visibleInstance {
    return visibleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    
    self.labelEmailReceipt.text = NSLocalizedString(@"Default Email Recipient", nil);
    self.labelTripLength.text = NSLocalizedString(@"Default Trip Length (Days)", nil);
    self.labelMinimumReceiptPrice.text = NSLocalizedString(@"Min. Receipt Price to Report", nil);
    self.labelUserId.text = NSLocalizedString(@"User ID", nil);
    
    self.labelDefaultCurrency.text = NSLocalizedString(@"Default Currency", nil);
    self.labelDateSeparator.text = NSLocalizedString(@"Date Separator", nil);
    self.labelCameraWidthHeight.text = NSLocalizedString(@"Max. Camera Height / Width", nil);
    
    self.labelPredictReceiptCategories.text = NSLocalizedString(@"Predict Receipt Categories", nil);
    self.labelIncludeTaxForReceipts.text = NSLocalizedString(@"Include Tax Field For Receipts", nil);
    self.labelMatchNameToCategories.text = NSLocalizedString(@"Match Name to Categories", nil);
    self.labelMatchCommentsToCategories.text = NSLocalizedString(@"Match Comments to Categories", nil);
    self.labelOnlyReportExpensableReceipts.text = NSLocalizedString(@"Only Report Expensable Receipts", nil);
    self.labelEnableAutoCompleteSuggestions.text = NSLocalizedString(@"Enable AutoComplete Suggestions", nil);
    self.labelDefaultReceiptDateToReportStartDate.text = NSLocalizedString(@"Default Receipt Date to Report Start Date", nil);
    
    self.labelIncludeHeaderColumns.text = NSLocalizedString(@"Include Header Columns", nil);
    
    self.labelManageCategories.text = NSLocalizedString(@"Manage Categories", nil);
    self.labelConfigureCsvColumns.text = NSLocalizedString(@"Configure CSV Columns", nil);
    self.labelConfigurePdfColumns.text = NSLocalizedString(@"Configure PDF Columns", nil);
    self.labelMakeBackup.text = NSLocalizedString(@"Make Backup", nil);
    
    currencyCodes = [WBCurrency allCurrencyCodes];
    currentCurrencyCode = @"USD";
    
    dynamicPicker = [[WBDynamicPicker alloc] initWithType:WBDynamicPickerTypePicker withController:self];
    [dynamicPicker setTitle:NSLocalizedString(@"Currencies",nil)];
    dynamicPicker.delegate = self;

    self.tripLengthField.delegate = self;
    self.userIdField.delegate = self;
    self.minimumReceiptPriceField.delegate = self;
    
    [self.navigationController setToolbarHidden:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"General", nil);
        case 1:
            return NSLocalizedString(@"Categories", nil);
        case 2:
            return NSLocalizedString(@"Customize CSV Output", nil);
        case 3:
            return NSLocalizedString(@"Customize PDF Output", nil);
        case 4:
            return NSLocalizedString(@"Backup", nil);
        default:
            return NSLocalizedString(@"", nil);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (void)populateValues {
    self.emailReceiptField.text = [WBPreferences defaultEmailReceipient];
    self.tripLengthField.text = [NSString stringWithFormat:@"%d",[WBPreferences defaultTripDuration]];
    self.userIdField.text = [WBPreferences userID];
    self.predictReceiptCategoriesField.on = [WBPreferences predictCategories];
    
    self.includeTaxFieldForReceiptsField.on = [WBPreferences includeTaxField];
    self.matchNameToCategoriesField.on = [WBPreferences matchNameToCategory];
    self.matchCommentsToCategoriesField.on = [WBPreferences matchCommentToCategory];
    self.onlyReportExpensableReceiptsField.on = [WBPreferences onlyIncludeExpensableReceiptsInReports];
    
    self.enableAutoCompleteSuggestionsField.on = [WBPreferences enableAutoCompleteSuggestions];
    self.defaultReceiptDateToReportStartDateField.on = [WBPreferences defaultToFirstReportDate];
    
#warning REVIEW: taking MIN_FLOAT is risky because they are not guaranted to have the same representation
    
    double price = [WBPreferences minimumReceiptPriceToIncludeInReports];
    double minPrice = ([WBPreferences MIN_FLOAT]/4.0); // we have to make significant change because it's long float and have little precision
    if (price < minPrice) {
        self.minimumReceiptPriceField.text = @"";
    } else {
        long long priceLong = roundl(price);
        self.minimumReceiptPriceField.text = [NSString stringWithFormat:@"%lld",priceLong];
    }
    
    [self.defaultCurrencyButton setTitle:[WBPreferences defaultCurrency] forState:UIControlStateNormal];

    NSArray *separators = @[@"-", @"/", @"."];
    NSString *systemSeparator = [[[WBDateFormatter alloc] init] separatorForCurrentLocale];
    if ([separators indexOfObject:systemSeparator] == NSNotFound) {
        separators = [separators arrayByAddingObject:systemSeparator];
    }

    [self.dateSeparatorField removeAllSegments];
    for (NSUInteger index = 0; index < separators.count; index++) {
        NSString *separator = separators[index];
        [self.dateSeparatorField insertSegmentWithTitle:separator atIndex:index animated:NO];
    }

    NSUInteger idx = [separators indexOfObject:[WBPreferences dateSeparator]];
    if (idx == NSNotFound) {
        idx = 1;
    }
    [self.dateSeparatorField setSelectedSegmentIndex:idx];
    
    cameraValues = @[@512, @1024, @0];
    
    [self.cameraWidthHeightField removeAllSegments];
    
    int selected = 1;
    for (int i = 0; i< cameraValues.count; ++i) {
        int val = [((NSNumber*)[cameraValues objectAtIndex:i]) intValue];
        if (val == 0) {
            [self.cameraWidthHeightField
             insertSegmentWithTitle:NSLocalizedString(@"Default", nil)
             atIndex:i animated:NO];
        } else {
            NSString *str = [NSString stringWithFormat:@"%d %@", val, NSLocalizedString(@"Pixels", nil)];
            [self.cameraWidthHeightField
             insertSegmentWithTitle:str
             atIndex:i animated:NO];
        }
        
        if (val == [WBPreferences cameraMaxHeightWidth]) {
            selected = i;
        }
    }
    [self.cameraWidthHeightField setSelectedSegmentIndex:selected];
    
    self.includeHeaderColumnsField.on = [WBPreferences includeCSVHeaders];
}

- (void)writeSettingsToPreferences {
    NSString *daysStr = self.tripLengthField.text;
    if ([daysStr length] > 0 && [daysStr length] < 4) {
        [WBPreferences setDefaultTripDuration:[daysStr intValue]];
    }
    
    NSString *priceStr = self.minimumReceiptPriceField.text;
    if ([priceStr length] > 0 && [priceStr length] < 4) {
        [WBPreferences setMinimumReceiptPriceToIncludeInReports:[priceStr floatValue]];
    } else if ([priceStr length] == 0) {
        [WBPreferences setMinimumReceiptPriceToIncludeInReports:[WBPreferences MIN_FLOAT]];
    }

    [WBPreferences setDefaultEmailReceipient:self.emailReceiptField.text];
    [WBPreferences setDefaultCurrency:[self.defaultCurrencyButton titleForState:UIControlStateNormal]];
    [WBPreferences setPredictCategories:self.predictReceiptCategoriesField.on];
    
    [WBPreferences setMatchNameToCategory:self.matchNameToCategoriesField.on];
    [WBPreferences setMatchCommentToCategory:self.matchCommentsToCategoriesField.on];
    [WBPreferences setOnlyIncludeExpensableReceiptsInReports:self.onlyReportExpensableReceiptsField.on];
    [WBPreferences setIncludeTaxField:self.includeTaxFieldForReceiptsField.on];
    
    [WBPreferences setEnableAutoCompleteSuggestions:self.enableAutoCompleteSuggestionsField.on];
    [WBPreferences setUserID:self.userIdField.text];
    [WBPreferences setDateSeparator:[self.dateSeparatorField titleForSegmentAtIndex:self.dateSeparatorField.selectedSegmentIndex]];
    [WBPreferences setDefaultToFirstReportDate:self.defaultReceiptDateToReportStartDateField.on];

    NSNumber *cam = [cameraValues objectAtIndex:[self.cameraWidthHeightField selectedSegmentIndex]];
    [WBPreferences setCameraMaxHeightWidth:[cam intValue]];
    
    [WBPreferences setIncludeCSVHeaders:self.includeHeaderColumnsField.on];

    [WBPreferences save];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self populateValues];
    visibleInstance = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    visibleInstance = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
#warning REVIEW: money everywhere are %.2f format but here we limit them to integer
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    if (textField == self.minimumReceiptPriceField) {
//        return [WBTextUtils isNonnegativeMoney:str];
//    } else {
        return [WBTextUtils isNonnegativeInteger:str];
//    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] hasPrefix:@"Configure"]) {
        WBColumnsViewController* vc = (WBColumnsViewController*)[segue destinationViewController];
        vc.forCSV = [[segue identifier] isEqualToString:@"ConfigureCSV"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 101) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self actionExport];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=1) {
        return;
    }
    
    [HUD showUIBlockingIndicatorWithText:NSLocalizedString(@"Exporting ...", nil)];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = nil;
        @try {
            NSString *path = [[[WBBackupHelper alloc] init] exportAll];
            if (path) {
                data = [NSData dataWithContentsOfFile:path];
            }
        } @catch (NSException *e) {
            data = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUIBlockingIndicator];
            
            if (data) {
                [self showMailerForData:data];
            } else {
                [[[UIAlertView alloc]
                 initWithTitle:NSLocalizedString(@"Error", nil)
                 message:NSLocalizedString(@"Failed to properly export your data.", nil)
                 delegate:nil
                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                 otherButtonTitles:nil] show];
            }
            
        });
    });
}

- (void) showMailerForData:(NSData*) data {
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    // forward our navbar tint color to mail composer
    [mc.navigationBar setTintColor:[UINavigationBar appearance].tintColor];

    [mc setToRecipients:@[[WBPreferences defaultEmailReceipient]]];
    [mc addAttachmentData:data
                 mimeType:@"application/octet-stream"
                 fileName:@"SmartReceipts.smr"];
    
    // forward style, mail composer is so dumb and overrides our style
    UIStatusBarStyle barStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [self presentViewController:mc animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if (error) {
        NSLog(@"Mail error: %@", [error localizedDescription]);
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionExport {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Export your receipts?", nil)
                          message:NSLocalizedString(@"You can reimport your data by clicking on the SmartReceipts.SMR file, which is generated by clicking below.", nil)
                          delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                          otherButtonTitles:NSLocalizedString(@"Export", nil), nil];
    [alert show];
}

-(NSString*) dynamicPicker:(WBDynamicPicker*) dynamicPicker titleForRow:(NSInteger) row
{
    return [currencyCodes objectAtIndex:row];
}

-(NSInteger) dynamicPickerNumberOfRows:(WBDynamicPicker*) dynamicPicker
{
    return currencyCodes.count;
}

-(void)dynamicPicker:(WBDynamicPicker *)picker doneWith:(id)subject{
    currentCurrencyCode = [currencyCodes objectAtIndex:[picker selectedRow]];
    self.defaultCurrencyButton.titleLabel.text = currentCurrencyCode;
    [self.defaultCurrencyButton setTitle:currentCurrencyCode forState:UIControlStateNormal];
}

- (IBAction)defaultCurrencyClicked:(id)sender {
    pickedRow = (int)[currencyCodes indexOfObject:currentCurrencyCode];
    [dynamicPicker setSelectedRow:pickedRow];
    [dynamicPicker showFromView:self.defaultCurrencyButton];
}

- (IBAction)actionDone:(id)sender {
    [self writeSettingsToPreferences];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
