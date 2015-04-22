//
//  WBNewReceiptViewController.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBNewReceiptViewController.h"

#import "WBReceiptsViewController.h"

#import "WBTextUtils.h"
#import "WBDateFormatter.h"

#import "WBReceipt.h"
#import "WBCurrency.h"

#import "WBDB.h"
#import "WBPreferences.h"
#import "WBFileManager.h"

#import "WBAutocompleteHelper.h"
#import "WBPrice.h"
#import "NSDecimalNumber+WBNumberParse.h"

static const int TAG_CURRENCY = 1, TAG_CATEGORY = 2;

@interface WBNewReceiptViewController () {
    WBDynamicPicker* _dynamicPicker;
    WBDynamicPicker* _dynamicDatePicker;
    
    WBDateFormatter* _dateFormatter;
    
    WBTrip *_trip;
    WBReceipt *_receipt;
    
    UIImage *_image;
    
    NSString *_name;
    long long _dateMs;
    NSString *_comment;
    BOOL _isExpensable;
    BOOL _isFullPage;
    
    NSTimeZone *_timeZone;
    
    NSArray *_categoriesNames;
    NSArray *_currenciesCodes;
    
    WBAutocompleteHelper *_autocompleteHelper;
}

@end

@implementation WBNewReceiptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelName.text = NSLocalizedString(@"Name", nil);
    self.labelPrice.text = NSLocalizedString(@"Price", nil);
    self.labelTax.text = NSLocalizedString(@"Tax", nil);
    
    self.labelCurrency.text = NSLocalizedString(@"Currency", nil);
    self.labelDate.text = NSLocalizedString(@"Date", nil);
    self.labelCategory.text = NSLocalizedString(@"Category", nil);
    
    self.labelComment.text = NSLocalizedString(@"Comment", nil);
    self.labelExpensable.text = NSLocalizedString(@"Expensable", nil);
    self.labelFullPageImage.text = NSLocalizedString(@"Full Page Image", nil);
    
    self.nameTextField.placeholder = NSLocalizedString(@"Name of your receipt", nil);
    self.priceTextField.placeholder = NSLocalizedString(@"e.g. 25.00", nil);
    self.taxTextField.placeholder = NSLocalizedString(@"e.g. 5.00", nil);
    self.commentField.placeholder = NSLocalizedString(@"Your comments here", nil);
    
    _categoriesNames = [[WBDB categories] categoriesNames];
    _currenciesCodes = [WBCurrency allCurrencyCodes];
    
    _dateFormatter = [[WBDateFormatter alloc] init];
    
    _dynamicPicker = [[WBDynamicPicker alloc] initWithType:WBDynamicPickerTypePicker withController:self];
    _dynamicPicker.delegate = self;
    
    _dynamicDatePicker = [[WBDynamicPicker alloc] initWithType:WBDynamicPickerTypeDate withController:self];
    _dynamicDatePicker.delegate = self;
    
    _autocompleteHelper = [[WBAutocompleteHelper alloc] initWithAutocompleteField:self.nameTextField inView:self.view useReceiptsHints:YES];
    
    self.priceTextField.delegate = self;
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.taxTextField.delegate = self;
    self.taxTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.nameTextField.delegate = self;
    
    [self.nameTextField becomeFirstResponder];
    
    NSString *currencyCode = nil;
    NSString *category = nil;
    
    if (_receipt) {
        self.navigationItem.title = NSLocalizedString(@"Edit Receipt", nil);
        self.nameTextField.text = [_receipt name];
        self.priceTextField.text = [_receipt price_as_string];
        self.taxTextField.text = [_receipt tax_as_string];
        currencyCode = [[_receipt currency] code];
        _dateMs = [_receipt dateMs];
        category = [_receipt category];
        self.commentField.text = [_receipt comment];
        self.expensableSwitch.on = [_receipt isExpensable];
        self.fullPageImageSwitch.on = [_receipt isFullPage];
        
        _timeZone = [_receipt timeZone];
    } else {
        self.navigationItem.title = NSLocalizedString(@"New Receipt", nil);
        
        currencyCode = [WBPreferences defaultCurrency];
        
        if ([WBPreferences defaultToFirstReportDate]) {
            _dateMs = [[_trip startDate] timeIntervalSince1970] * 1000;
        } else {
            _dateMs = [[NSDate date] timeIntervalSince1970] * 1000;
        }
        
        category = [self proposedCategory];
        
        _timeZone = [NSTimeZone localTimeZone];
    }
    
    if (!_receipt) {
        if ([WBPreferences matchNameToCategory]) {
            self.nameTextField.text = category;
        }
        if ([WBPreferences matchCommentToCategory]) {
            self.commentField.text = category;
        }
    }
    
    [self.currencyButton setTitle:currencyCode forState:UIControlStateNormal];
    [self.categoryButton setTitle:category forState:UIControlStateNormal];
    
    [self.dateButton setTitle:[_dateFormatter formattedDateMs:_dateMs inTimeZone:_timeZone] forState:UIControlStateNormal];
}

- (void) checkCategoryMatches {
    if ([WBPreferences matchNameToCategory]) {
        self.nameTextField.text = [self.categoryButton titleForState:UIControlStateNormal];
    }
    if ([WBPreferences matchCommentToCategory]) {
        self.commentField.text = [self.categoryButton titleForState:UIControlStateNormal];
    }
}

- (NSInteger) numberOfHiddenCells {
    return ![WBPreferences includeTaxField];
}

- (NSInteger) numberOfHiddenCellsAbove:(NSInteger) row {
    // Calculate how many cells are hidden above the given indexPath.row
    if ([WBPreferences includeTaxField]) {
        return 0;
    }
    else {
        if (row >= 2) { //Tax row
            return 1;
        }
        else {
            return 0;
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section] - [self numberOfHiddenCells];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Recalculate indexPath based on hidden cells
    indexPath = [self offsetIndexPath:indexPath];
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSIndexPath*)offsetIndexPath:(NSIndexPath*)indexPath
{
    int offsetSection = indexPath.section; // Also offset section if you intend to hide whole sections
    int offsetRow = indexPath.row + [self numberOfHiddenCellsAbove:indexPath.row];

    return [NSIndexPath indexPathForRow:offsetRow inSection:offsetSection];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // we hide 3rd (tax)
    if (indexPath.row == 2 && ![WBPreferences includeTaxField]) {
        return 0;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
*/
- (NSString*) proposedCategory {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];
    
    if ([WBPreferences predictCategories]) {
        if (hour >= 4 && hour < 11) {
            return [WBCategory CATEGORY_NAME_BREAKFAST];
        } else if(hour >= 11 && hour < 16){
            return [WBCategory CATEGORY_NAME_LUNCH];
        } else if(hour >= 16 && hour < 23){
            return [WBCategory CATEGORY_NAME_DINNER];
        }
    }
    
    return _categoriesNames.count > 0 ? [_categoriesNames objectAtIndex:0] : @"";
}

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip*) trip{
    _receipt = receipt;
    _trip = trip;
}

- (void)setReceiptImage:(UIImage *)image{
    _image = image;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [_autocompleteHelper textFieldDidBeginEditing:textField];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_autocompleteHelper textFieldDidEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.priceTextField == textField || self.taxTextField == textField) {
        return [WBTextUtils isMoney:newText];
    }
    // receipt name is not filtered
    //else {
    //    return [WBTextUtils isProperName:newText];
    //}
    return YES;
}

-(NSString*) dynamicPicker:(WBDynamicPicker*) picker titleForRow:(NSInteger) row
{
    if (picker.tag == TAG_CURRENCY) {
        return [_currenciesCodes objectAtIndex:row];
    } else {
        return [_categoriesNames objectAtIndex:row];
    }
}

-(NSInteger) dynamicPickerNumberOfRows:(WBDynamicPicker*) picker
{
    if (picker.tag == TAG_CURRENCY) {
        return _currenciesCodes.count;
    } else {
        return _categoriesNames.count;
    }
}

-(void)dynamicPicker:(WBDynamicPicker *)picker doneWith:(id)subject
{
    if (picker == _dynamicPicker) {
        if (picker.tag == TAG_CATEGORY) {
            [self.categoryButton setTitle:[_categoriesNames objectAtIndex:[picker selectedRow]]
                                 forState:UIControlStateNormal];
            
            [self checkCategoryMatches];
        } else {
            [self.currencyButton setTitle:[_currenciesCodes objectAtIndex:[picker selectedRow]]
                                 forState:UIControlStateNormal];
        }
    } else {
        _dateMs = [[picker selectedDate] timeIntervalSince1970] * 1000;
        [self.dateButton setTitle:[_dateFormatter formattedDate:[picker selectedDate] inTimeZone:_timeZone] forState:UIControlStateNormal];
    }
}

- (IBAction)currencyButtonClicked:(id)sender {
    _dynamicPicker.tag = TAG_CURRENCY;
    [_dynamicPicker setTitle:NSLocalizedString(@"Currencies",nil)];
    [_dynamicPicker showFromView:self.currencyButton];
    
    NSUInteger currIdx = [_currenciesCodes indexOfObject:[self.currencyButton.titleLabel text]];
    [_dynamicPicker setSelectedRow:(currIdx==NSNotFound?0:currIdx)];
}

- (IBAction)categoryButtonClicked:(id)sender {
    _dynamicPicker.tag = TAG_CATEGORY;
    [_dynamicPicker setTitle:NSLocalizedString(@"Categories",nil)];
    [_dynamicPicker showFromView:self.categoryButton];
    
    NSUInteger catIdx = [_categoriesNames indexOfObject:[self.categoryButton.titleLabel text]];
    if (_categoriesNames.count>0) {
        [_dynamicPicker setSelectedRow:(catIdx==NSNotFound?0:catIdx)];
    }
}

- (IBAction)dateButtonClicked:(id)sender {
    [_dynamicDatePicker setDate:[NSDate dateWithTimeIntervalSince1970:(_dateMs/1000)]];
    [_dynamicDatePicker showFromView:self.dateButton];
}

- (IBAction)actionDone:(id)sender {
    WBReceipt* newReceipt;
    
    NSString* name = [self.nameTextField.text lastPathComponent];
    if ([name length]<=0) {
        [WBNewReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"Please enter a name",nil)];
        return;
    }

    NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZero:self.priceTextField.text withLocale:[NSLocale currentLocale]];
    NSDecimalNumber *tax = [NSDecimalNumber decimalNumberOrZero:self.taxTextField.text withLocale:[NSLocale currentLocale]];

    if (_receipt == nil) {
        
        NSString *imageFileName = nil;
        if (_image) {
            long long ms = ([[NSDate date] timeIntervalSince1970] * 1000LL);
            imageFileName = [NSString stringWithFormat:@"%lldx%d.jpg", ms, (int)[self.receiptsViewController receiptsCount]];
            NSString *path = [_trip fileInDirectoryPath:imageFileName];
            if(![WBFileManager forceWriteData:UIImageJPEGRepresentation(_image, 0.85) to:path]) {
                imageFileName = nil;
            }
        }

        NSString *currencyCode = [self.currencyButton titleForState:UIControlStateNormal];
        newReceipt =
        [[WBDB receipts] insertWithTrip:_trip
                                   name:name
                               category:[self.categoryButton titleForState:UIControlStateNormal]
                          imageFileName:imageFileName
                                 dateMs:_dateMs
                           timeZoneName:[_timeZone name]
                                comment:self.commentField.text
                                  price:[WBPrice priceWithAmount:price currencyCode:currencyCode]
                                    tax:[WBPrice priceWithAmount:tax currencyCode:currencyCode]
                           isExpensable:self.expensableSwitch.on
                             isFullPage:self.fullPageImageSwitch.on
                         extraEditText1:nil
                         extraEditText2:nil
                         extraEditText3:nil];
        
        if(!newReceipt){
            [WBNewReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"Cannot add this receipt",nil)];
            return;
        }
        [self.delegate viewController:self newReceipt:newReceipt];
    } else {

        NSString *currencyCode = [self.currencyButton.titleLabel text];
        newReceipt =
        [[WBDB receipts] updateReceipt:_receipt
                                  trip:_trip
                                  name:name
                              category:[self.categoryButton.titleLabel text]
                                dateMs:_dateMs
                               comment:self.commentField.text
                                 price:[WBPrice priceWithAmount:price currencyCode:currencyCode]
                                   tax:[WBPrice priceWithAmount:tax currencyCode:currencyCode]
                          isExpensable:self.expensableSwitch.on
                            isFullPage:self.fullPageImageSwitch.on
                        extraEditText1:nil
                        extraEditText2:nil
                        extraEditText3:nil];
        
        if(!newReceipt){
            [WBNewReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"Cannot save this receipt",nil)];
            return;
        }
        [self.delegate viewController:self updatedReceipt:newReceipt fromReceipt:_receipt];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString*) title message:(NSString*) message {
    [[[UIAlertView alloc]
      initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
}

@end
