//
//  EditReceiptViewController.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "EditReceiptViewController.h"

#import "WBReceiptsViewController.h"

#import "WBDateFormatter.h"

#import "WBCurrency.h"

#import "WBDB.h"
#import "WBPreferences.h"
#import "WBFileManager.h"

#import "WBAutocompleteHelper.h"
#import "WBPrice.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "WBCustomization.h"
#import "TitledTextEntryCell.h"
#import "UIView+LoadHelpers.h"
#import "UITableViewCell+Identifier.h"
#import "PickerCell.h"
#import "SwitchControlCell.h"
#import "InputCellsSection.h"
#import "InlinedPickerCell.h"
#import "InlinedDatePickerCell.h"
#import "TitledAutocompleteEntryCell.h"
#import "Database+PaymentMethods.h"
#import "FetchedModelAdapter.h"
#import "Pickable.h"
#import "StringPickableWrapper.h"

@interface EditReceiptViewController () <WBDynamicPickerDelegate,UITextFieldDelegate> {
    UIImage *_image;
    
    NSString *_name;

    NSTimeZone *_timeZone;
}

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong) WBReceipt *receipt;

@property (nonatomic, strong) WBDateFormatter *dateFormatter;

@property (nonatomic, assign) long long dateMs;

@property (nonatomic, strong) TitledAutocompleteEntryCell *nameCell;
@property (nonatomic, strong) TitledTextEntryCell *priceCell;
@property (nonatomic, strong) TitledTextEntryCell *taxCell;
@property (nonatomic, strong) PickerCell *currencyCell;
@property (nonatomic, strong) InlinedPickerCell *currencyPickerCell;
@property (nonatomic, strong) PickerCell *dateCell;
@property (nonatomic, strong) InlinedDatePickerCell *datePickerCell;
@property (nonatomic, strong) PickerCell *categoryCell;
@property (nonatomic, strong) InlinedPickerCell *categoryPickerCell;
@property (nonatomic, strong) TitledTextEntryCell *commentCell;
@property (nonatomic, strong) PickerCell *paymenMethodCell;
@property (nonatomic, strong) InlinedPickerCell *paymenMethodPickerCell;
@property (nonatomic, strong) SwitchControlCell *expenseableCell;
@property (nonatomic, strong) SwitchControlCell *fullPageImageCell;

@property (nonatomic, strong) NSArray *categoryNames;

@end

@implementation EditReceiptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    __weak EditReceiptViewController *weakSelf = self;

    self.dateFormatter = [[WBDateFormatter alloc] init];

    [self.tableView registerNib:[TitledAutocompleteEntryCell viewNib] forCellReuseIdentifier:[TitledAutocompleteEntryCell cellIdentifier]];
    [self.tableView registerNib:[TitledTextEntryCell viewNib] forCellReuseIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[PickerCell viewNib] forCellReuseIdentifier:[PickerCell cellIdentifier]];
    [self.tableView registerNib:[SwitchControlCell viewNib] forCellReuseIdentifier:[SwitchControlCell cellIdentifier]];
    [self.tableView registerNib:[InlinedPickerCell viewNib] forCellReuseIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedDatePickerCell viewNib] forCellReuseIdentifier:[InlinedDatePickerCell cellIdentifier]];

    self.nameCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledAutocompleteEntryCell cellIdentifier]];
    [self.nameCell setTitle:NSLocalizedString(@"Name", nil)];
    [self.nameCell setPlaceholder:NSLocalizedString(@"Name of your receipt", nil)];
    [self.nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [self.nameCell setAutocompleteHelper:[[WBAutocompleteHelper alloc] initWithAutocompleteField:(HTAutocompleteTextField *) self.nameCell.entryField inView:self.view useReceiptsHints:YES]];

    self.priceCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.priceCell setTitle:NSLocalizedString(@"Price", nil)];
    [self.priceCell setPlaceholder:NSLocalizedString(@"e.g. 25.00", nil)];
    [self.priceCell activateDecimalEntryMode];

    self.taxCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.taxCell setTitle:NSLocalizedString(@"Tax", nil)];
    [self.taxCell setPlaceholder:NSLocalizedString(@"e.g. 5.00", nil)];
    [self.taxCell activateDecimalEntryMode];

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"Currency", nil)];

    self.currencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.currencyPickerCell setAllValues:[WBCurrency allCurrencyCodes]];
    [self.currencyPickerCell setValueChangeHandler:^(id<Pickable> selected) {
        [weakSelf.currencyCell setValue:selected.presentedValue];
    }];

    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.dateCell setTitle:NSLocalizedString(@"Date", nil)];

    self.datePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.datePickerCell setChangeHandler:^(NSDate *selected) {
        [weakSelf.dateCell setValue:[weakSelf.dateFormatter formattedDate:selected inTimeZone:[NSTimeZone localTimeZone]]];
        weakSelf.dateMs = (long long int) (selected.timeIntervalSince1970 * 1000);
    }];
    [self.datePickerCell setMinDate:self.trip.startDate maxDate:self.trip.endDate];

    self.categoryCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.categoryCell setTitle:NSLocalizedString(@"Category", nil)];

    self.categoryPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    self.categoryNames = [[WBDB categories] categoriesNames];
    [self.categoryPickerCell setAllValues:self.categoryNames];
    [self.categoryPickerCell setValueChangeHandler:^(id<Pickable> selected) {
        [weakSelf.categoryCell setValue:selected.presentedValue];
        [weakSelf checkCategoryMatches];
    }];

    self.commentCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.commentCell setTitle:NSLocalizedString(@"Comment", nil)];
    [self.commentCell setPlaceholder:NSLocalizedString(@"Your comments here", nil)];
    [self.commentCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    self.paymenMethodCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.paymenMethodCell setTitle:NSLocalizedString(@"Payment Method", nil)];

    self.paymenMethodPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.paymenMethodPickerCell setAllPickabelValues:[[[Database sharedInstance] fetchedAdapterForPaymentMethods] allObjects]];
    [self.paymenMethodPickerCell setValueChangeHandler:^(id<Pickable> selected) {
        [weakSelf.paymenMethodCell setValue:selected.presentedValue];
    }];

    self.expenseableCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.expenseableCell setTitle:NSLocalizedString(@"Expensable", nil)];

    self.fullPageImageCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.fullPageImageCell setTitle:NSLocalizedString(@"Full Page Image", nil)];

    NSMutableArray *presentedCells = [NSMutableArray array];
    [presentedCells addObject:self.nameCell];
    [presentedCells addObject:self.priceCell];
    if ([WBPreferences includeTaxField]) {
        [presentedCells addObject:self.taxCell];
    }
    [presentedCells addObject:self.currencyCell];
    [presentedCells addObject:self.dateCell];
    [presentedCells addObject:self.categoryCell];
    [presentedCells addObject:self.commentCell];
    if ([WBPreferences usePaymentMethods]) {
        [presentedCells addObject:self.paymenMethodCell];
    }
    [presentedCells addObject:self.expenseableCell];
    [presentedCells addObject:self.fullPageImageCell];

    [self addSectionForPresentation:[InputCellsSection sectionWithCells:presentedCells]];

    [self addInlinedPickerCell:self.currencyPickerCell forCell:self.currencyCell];
    [self addInlinedPickerCell:self.datePickerCell forCell:self.dateCell];
    [self addInlinedPickerCell:self.categoryPickerCell forCell:self.categoryCell];
    [self addInlinedPickerCell:self.paymenMethodPickerCell forCell:self.paymenMethodCell];

    [self.nameCell.entryField becomeFirstResponder];

    [self loadDataToCells];
}

- (void)loadDataToCells {
    NSString *currencyCode = nil;
    NSString *category = nil;

    if (self.receipt) {
        [self.navigationItem setTitle:NSLocalizedString(@"Edit Receipt", nil)];
        [self.nameCell setValue:[self.receipt name]];
        [self.priceCell setValue:[self.receipt priceAsString]];
        [self.taxCell setValue:[self.receipt taxAsString]];
        currencyCode = [[self.receipt currency] code];
        _dateMs = [self.receipt dateMs];
        category = [self.receipt category];
        [self.commentCell setValue:[self.receipt comment]];
        [self.expenseableCell setSwitchOn:[self.receipt isExpensable]];
        [self.fullPageImageCell setSwitchOn:[self.receipt isFullPage]];
        _timeZone = [self.receipt timeZone];
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

        [self.expenseableCell setSwitchOn:YES];
        [self.fullPageImageCell setSwitchOn:NO];
    }

    if (!_receipt) {
        if ([WBPreferences matchNameToCategory]) {
            [self.nameCell setValue:category];
        }
        if ([WBPreferences matchCommentToCategory]) {
            [self.commentCell setValue:category];
        }
    }

    [self.currencyCell setValue:currencyCode];
    [self.currencyPickerCell setSelectedValue:[StringPickableWrapper wrapValue:currencyCode]];

    [self.categoryCell setValue:category];
    [self.categoryPickerCell setSelectedValue:[StringPickableWrapper wrapValue:category]];

    [self.dateCell setValue:[_dateFormatter formattedDateMs:_dateMs inTimeZone:_timeZone]];
    [self.datePickerCell setDate:[NSDate dateWithTimeIntervalSince1970:_dateMs / 1000]];

}

- (void)checkCategoryMatches {
    if ([WBPreferences matchNameToCategory]) {
        [self.nameCell setValue:[self.categoryCell value]];
    }
    if ([WBPreferences matchCommentToCategory]) {
        [self.commentCell setValue:[self.currencyCell value]];
    }
}

- (NSString *)proposedCategory {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];

    if ([WBPreferences predictCategories]) {
        if (hour >= 4 && hour < 11) {
            return [WBCategory CATEGORY_NAME_BREAKFAST];
        } else if (hour >= 11 && hour < 16) {
            return [WBCategory CATEGORY_NAME_LUNCH];
        } else if (hour >= 16 && hour < 23) {
            return [WBCategory CATEGORY_NAME_DINNER];
        }
    }

    return self.categoryNames.count > 0 ? [self.categoryNames firstObject] : @"";
}

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip*) trip{
    _receipt = receipt;
    _trip = trip;
}

- (void)setReceiptImage:(UIImage *)image{
    _image = image;
}

- (IBAction)actionDone:(id)sender {
    WBReceipt* newReceipt;

    NSString *name = [[self.nameCell value] lastPathComponent];
    if ([name length] <= 0) {
        [EditReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"Please enter a name", nil)];
        return;
    }

    NSDecimalNumber *price = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.priceCell.value];
    NSDecimalNumber *tax = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.taxCell.value];

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

        NSString *currencyCode = [self.currencyCell value];
        newReceipt =
        [[WBDB receipts] insertWithTrip:_trip
                                   name:name
                               category:[self.categoryCell value]
                          imageFileName:imageFileName
                                 dateMs:_dateMs
                           timeZoneName:[_timeZone name]
                                comment:[self.commentCell value]
                                  price:[WBPrice priceWithAmount:price currencyCode:currencyCode]
                                    tax:[WBPrice priceWithAmount:tax currencyCode:currencyCode]
                           isExpensable:self.expenseableCell.isSwitchOn
                             isFullPage:self.fullPageImageCell.isSwitchOn
                         extraEditText1:nil
                         extraEditText2:nil
                         extraEditText3:nil];
        
        if(!newReceipt){
            [EditReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"Cannot add this receipt", nil)];
            return;
        }
        [self.delegate viewController:self newReceipt:newReceipt];
    } else {

        NSString *currencyCode = [self.currencyCell value];
        newReceipt =
        [[WBDB receipts] updateReceipt:_receipt
                                  trip:_trip
                                  name:name
                              category:[self.categoryCell value]
                                dateMs:_dateMs
                               comment:[self.commentCell value]
                                 price:[WBPrice priceWithAmount:price currencyCode:currencyCode]
                                   tax:[WBPrice priceWithAmount:tax currencyCode:currencyCode]
                          isExpensable:self.expenseableCell.isSwitchOn
                            isFullPage:self.fullPageImageCell.isSwitchOn
                        extraEditText1:nil
                        extraEditText2:nil
                        extraEditText3:nil];
        
        if(!newReceipt){
            [EditReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"Cannot save this receipt", nil)];
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
