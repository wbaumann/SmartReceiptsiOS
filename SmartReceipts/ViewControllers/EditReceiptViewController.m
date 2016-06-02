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
#import "WBPreferences.h"
#import "WBFileManager.h"
#import "WBAutocompleteHelper.h"
#import "Price.h"
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
#import "PaymentMethod.h"
#import "Database+Receipts.h"
#import "NSDate+Calculations.h"
#import "TaxCalculator.h"
#import "WBTrip.h"
#import "WBReceipt.h"
#import "WBCategory.h"
#import "Database+Categories.h"
#import "Constants.h"
#import "SmartReceipts-Swift.h"

NSString *const SREditReceiptDateCacheKey = @"SREditReceiptDateCacheKey";
NSString *const SREditReceiptCategoryCacheKey = @"SREditReceiptCategoryCacheKey";

@interface EditReceiptViewController ()

@property (nonatomic, strong) WBTrip *trip;
@property (nonatomic, strong) WBReceipt *receipt;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, assign) long long dateMs;
@property (nonatomic, strong) NSTimeZone *timeZone;

@property (nonatomic, strong) TitledAutocompleteEntryCell *nameCell;
@property (nonatomic, strong) TitledTextEntryCell *priceCell;
@property (nonatomic, strong) TitledTextEntryCell *taxCell;
@property (nonatomic, strong) PickerCell *currencyCell;
@property (nonatomic, strong) InlinedPickerCell *currencyPickerCell;
@property (nonatomic, strong) ExchangeRateCell *exchangeRateCell;
@property (nonatomic, strong) PickerCell *dateCell;
@property (nonatomic, strong) InlinedDatePickerCell *datePickerCell;
@property (nonatomic, strong) PickerCell *categoryCell;
@property (nonatomic, strong) InlinedPickerCell *categoryPickerCell;
@property (nonatomic, strong) TitledTextEntryCell *commentCell;
@property (nonatomic, strong) PickerCell *paymentMethodCell;
@property (nonatomic, strong) InlinedPickerCell *paymentMethodPickerCell;
@property (nonatomic, strong) SwitchControlCell *expensableCell;
@property (nonatomic, strong) SwitchControlCell *fullPageImageCell;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) TaxCalculator *taxCalculator;

@end

@implementation EditReceiptViewController

- (void)viewDidLoad {
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
    [self.tableView registerNib:[ExchangeRateCell viewNib] forCellReuseIdentifier:[ExchangeRateCell cellIdentifier]];

    self.nameCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledAutocompleteEntryCell cellIdentifier]];
    [self.nameCell setTitle:NSLocalizedString(@"edit.receipt.name.label", nil)];
    [self.nameCell setPlaceholder:NSLocalizedString(@"edit.receipt.name.placeholder", nil)];
    [self.nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [self.nameCell setAutocompleteHelper:[[WBAutocompleteHelper alloc] initWithAutocompleteField:(HTAutocompleteTextField *) self.nameCell.entryField inView:self.view useReceiptsHints:YES]];

    self.priceCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    self.priceCell.title = NSLocalizedString(@"edit.receipt.price.label", nil);
    [self.priceCell setPlaceholder:NSLocalizedString(@"edit.receipt.price.placeholder", nil)];
    [self.priceCell activateDecimalEntryMode];

    self.taxCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.taxCell setTitle:NSLocalizedString(@"edit.receipt.tax.label", nil)];
    [self.taxCell setPlaceholder:NSLocalizedString(@"edit.receipt.tax.placeholder", nil)];
    [self.taxCell activateDecimalEntryMode];

    if ([WBPreferences includeTaxField]) {
        TaxCalculator *calculator = [[TaxCalculator alloc] initWithSourceField:self.priceCell.entryField targetField:self.taxCell.entryField];
        [calculator setPriceIsPreTax:[WBPreferences enteredPricePreTax]];
        [calculator setTaxPercentage:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", [WBPreferences defaultTaxPercentage]]]];
        [self setTaxCalculator:calculator];
    }

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"edit.receipt.currency.label", nil)];

    self.currencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.currencyPickerCell setAllValues:[WBCurrency allCurrencyCodes]];
    [self.currencyPickerCell setValueChangeHandler:^(id <Pickable> selected) {
        NSString *currency = [selected presentedValue];
        [weakSelf.currencyCell setValue:currency];
        
        NSString *tripCurrency = weakSelf.trip.defaultCurrency.code;
        BOOL isDifferentFromTripCurrency = ![tripCurrency isEqualToString:currency];
        if (isDifferentFromTripCurrency) {
            [weakSelf insert:weakSelf.exchangeRateCell afterCell:weakSelf.currencyCell];
            [weakSelf triggerExchangeRateUpdate];
        } else {
            [weakSelf remove:weakSelf.exchangeRateCell];
        }
    }];
    
    self.exchangeRateCell = [self.tableView dequeueReusableCellWithIdentifier:[ExchangeRateCell cellIdentifier]];
    [self.exchangeRateCell setTitle:NSLocalizedString(@"edit.receipt.exchange.rate.label", nil)];
    [self.exchangeRateCell activateDecimalEntryModeWithDecimalPlaces:SmartReceiptExchangeRateDecimalPlaces];
    self.exchangeRateCell.accessoryView = [self exchangeRateReloadButton];

    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    self.dateCell.title = NSLocalizedString(@"edit.receipt.date.label", nil);

    self.datePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.datePickerCell setChangeHandler:^(NSDate *selected) {
        [weakSelf.dateCell setValue:[weakSelf.dateFormatter formattedDate:selected inTimeZone:[NSTimeZone localTimeZone]]];
        weakSelf.dateMs = (long long int) (selected.timeIntervalSince1970 * 1000);

        [WBReceiptsViewController sharedInputCache][SREditReceiptDateCacheKey] = selected;

        if ([weakSelf.trip dateOutsideTripBounds:selected]) {
            [weakSelf.dateCell addWarningWithTitle:NSLocalizedString(@"edit.receipt.date.range.warning.title", nil)
                                           message:NSLocalizedString(@"edit.receipt.date.range.warning.message", nil)];
        } else {
            [weakSelf.dateCell removeWarning];
        }
        
        [weakSelf triggerExchangeRateUpdate];
    }];

    if (![WBPreferences allowDataEntryOutsideTripBounds]) {
        [self.datePickerCell setMinDate:[self.trip.startDate dateAtBeginningOfDay] maxDate:[self.trip.endDate dateAtEndOfDay]];
    }

    self.categoryCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.categoryCell setTitle:NSLocalizedString(@"edit.receipt.category.label", nil)];

    self.categoryPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    self.categories = [[Database sharedInstance] listAllCategories];
    [self.categoryPickerCell setAllPickabelValues:self.categories];
    [self.categoryPickerCell setValueChangeHandler:^(id <Pickable> selected) {
        [WBReceiptsViewController sharedInputCache][SREditReceiptCategoryCacheKey] = selected.presentedValue;

        [weakSelf.categoryCell setValue:selected.presentedValue];
        [weakSelf checkCategoryMatches];
    }];

    self.commentCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.commentCell setTitle:NSLocalizedString(@"edit.receipt.comment.label", nil)];
    [self.commentCell setPlaceholder:NSLocalizedString(@"edit.receipt.comment.placeholder", nil)];
    [self.commentCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    self.paymentMethodCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.paymentMethodCell setTitle:NSLocalizedString(@"edit.receipt.payment.method.label", nil)];

    self.paymentMethodPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    NSArray *paymentMethods = [[[Database sharedInstance] fetchedAdapterForPaymentMethods] allObjects];
    [self.paymentMethodPickerCell setAllPickabelValues:paymentMethods];
    [self.paymentMethodPickerCell setSelectedValue:[self defaultPaymentMethodFrom:paymentMethods]];
    [self.paymentMethodPickerCell setValueChangeHandler:^(id <Pickable> selected) {
        [weakSelf.paymentMethodCell setPickableValue:selected];
    }];

    self.expensableCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.expensableCell setTitle:NSLocalizedString(@"edit.receipt.expensable.label", nil)];

    self.fullPageImageCell = [self.tableView dequeueReusableCellWithIdentifier:[SwitchControlCell cellIdentifier]];
    [self.fullPageImageCell setTitle:NSLocalizedString(@"edit.receipt.full.page.label", nil)];

    NSMutableArray *presentedCells = [NSMutableArray array];
    [presentedCells addObject:self.nameCell];
    [presentedCells addObject:self.priceCell];
    if ([WBPreferences includeTaxField]) {
        [presentedCells addObject:self.taxCell];
    }
    [presentedCells addObject:self.currencyCell];
    if (self.receipt && ![self.trip.defaultCurrency isEqual:self.receipt.currency]) {
        [presentedCells addObject:self.exchangeRateCell];
    }
    [presentedCells addObject:self.dateCell];
    [presentedCells addObject:self.categoryCell];
    [presentedCells addObject:self.commentCell];
    if ([WBPreferences usePaymentMethods]) {
        [presentedCells addObject:self.paymentMethodCell];
    }
    [presentedCells addObject:self.expensableCell];
    [presentedCells addObject:self.fullPageImageCell];

    [self addSectionForPresentation:[InputCellsSection sectionWithCells:presentedCells]];

    [self addInlinedPickerCell:self.currencyPickerCell forCell:self.currencyCell];
    [self addInlinedPickerCell:self.datePickerCell forCell:self.dateCell];
    [self addInlinedPickerCell:self.categoryPickerCell forCell:self.categoryCell];
    if ([WBPreferences usePaymentMethods]) {
        [self addInlinedPickerCell:self.paymentMethodPickerCell forCell:self.paymentMethodCell];
    }

    [self.nameCell.entryField becomeFirstResponder];

    [self loadDataToCells];
}

- (id <Pickable>)defaultPaymentMethodFrom:(NSArray *)methods {
    for (PaymentMethod *method in methods) {
        if ([NSLocalizedString(@"payment.method.unspecified", nil) isEqualToString:method.presentedValue]) {
            return method;
        }
    }

    return [methods lastObject];
}

- (void)loadDataToCells {
    NSString *currencyCode = nil;
    WBCategory *category = nil;

    NSString *controllerTitle;
    NSUInteger receiptID;

    if (self.receipt) {
        controllerTitle = NSLocalizedString(@"edit.receipt.controller.edit.title", nil);
        receiptID = self.receipt.objectId;

        [self.nameCell setValue:[self.receipt name]];
        [self.priceCell setValue:[self.receipt priceAsString]];
        [self.exchangeRateCell setValue:[self.receipt exchangeRateAsString]];
        [self.taxCell setValue:[self.receipt taxAsString]];
        currencyCode = [[self.receipt currency] code];
        _dateMs = [self.receipt date].milliseconds.longLongValue;
        category = [self categoryWithName:[self.receipt category]];
        [self.commentCell setValue:[self.receipt comment]];
        [self.expensableCell setSwitchOn:[self.receipt isExpensable]];
        [self.fullPageImageCell setSwitchOn:[self.receipt isFullPage]];
        if (self.receipt.paymentMethod) {
            [self.paymentMethodCell setPickableValue:self.receipt.paymentMethod];
            [self.paymentMethodPickerCell setSelectedValue:self.receipt.paymentMethod];
        } else {
            [self.paymentMethodCell setPickableValue:self.paymentMethodPickerCell.selectedValue];
        }
        _timeZone = [self.receipt timeZone];
    } else {
        controllerTitle = NSLocalizedString(@"edit.receipt.controller.add.title", nil);
        receiptID = [[Database sharedInstance] nextReceiptID];

        currencyCode = [self.trip.defaultCurrency code];

        NSDate *cachedDate = [WBReceiptsViewController sharedInputCache][SREditReceiptDateCacheKey];
        if (cachedDate) {
            _dateMs = [cachedDate timeIntervalSince1970] * 1000;
        } else if ([WBPreferences defaultToFirstReportDate]) {
            _dateMs = [[_trip startDate] timeIntervalSince1970] * 1000;
        } else {
            _dateMs = [[NSDate date] timeIntervalSince1970] * 1000;
        }

        NSString *cachedCategoryName = [WBReceiptsViewController sharedInputCache][SREditReceiptCategoryCacheKey];
        if (cachedCategoryName) {
            category = [self categoryWithName:cachedCategoryName];
        } else {
            category = [self categoryWithName:[self proposedCategory]];
        }

        _timeZone = [NSTimeZone localTimeZone];

        [self.expensableCell setSwitchOn:YES];
        [self.fullPageImageCell setSwitchOn:NO];
        [self.paymentMethodCell setPickableValue:self.paymentMethodPickerCell.selectedValue];
    }

    if (!_receipt) {
        if ([WBPreferences matchNameToCategory]) {
            [self.nameCell setValue:category.name];
        }
        if ([WBPreferences matchCommentToCategory]) {
            [self.commentCell setValue:category.name];
        }
    }

    if ([WBPreferences showReceiptID]) {
        controllerTitle = [controllerTitle stringByAppendingFormat:@" - %tu", receiptID];
    }
    [self.navigationItem setTitle:controllerTitle];

    [self.currencyCell setValue:currencyCode];
    [self.currencyPickerCell setSelectedValue:[StringPickableWrapper wrapValue:currencyCode]];

    SRLog(@"Category:%@", category);

    [self.categoryCell setPickableValue:category];
    [self.categoryPickerCell setSelectedValue:category];

    [self.dateCell setValue:[_dateFormatter formattedDateMs:_dateMs inTimeZone:_timeZone]];
    [self.datePickerCell setDate:[NSDate dateWithTimeIntervalSince1970:_dateMs / 1000]];

}

- (WBCategory *)categoryWithName:(NSString *)name {
    WBCategory *category = [self.categories filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        WBCategory *cat = evaluatedObject;
        return [name isEqualToString:cat.name];
    }]].firstObject;

    if (!category) {
        category = [[WBCategory alloc] initWithName:name code:@""];
    }

    return category;
}

- (void)checkCategoryMatches {
    if ([WBPreferences matchNameToCategory]) {
        [self.nameCell setValue:[self.categoryCell value]];
    }
    if ([WBPreferences matchCommentToCategory]) {
        [self.commentCell setValue:[self.categoryCell value]];
    }
}

- (NSString *)proposedCategory {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:now];
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
    if (self.categories.count > 0) {
        WBCategory* firstCategory = [self.categories firstObject];
        return firstCategory.name;
    } else {
        return @"";
    }
}

- (void)setReceipt:(WBReceipt *)receipt withTrip:(WBTrip *)trip {
    _receipt = receipt;
    _trip = trip;
}

- (IBAction)actionDone:(id)sender {
    NSString *name = [[self.nameCell value] lastPathComponent];
    if ([name length] <= 0) {
        [EditReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"edit.receipt.name.missing.alert.message", nil)];
        return;
    }

    NSDecimalNumber *priceAmount = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.priceCell.value];
    NSDecimalNumber *taxAmount = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.taxCell.value];

    if (!self.receipt) {
        self.receipt = [[WBReceipt alloc] init];
        [self.receipt setTrip:self.trip];
    }

    NSString *currencyCode = [self.currencyCell value];

    NSDecimalNumber *exchangeRate = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.exchangeRateCell.value];
    if ([self.trip.defaultCurrency.code isEqualToString:currencyCode]) {
        exchangeRate = [NSDecimalNumber decimalNumberOrZero:@"-1"];
    }

    [self.receipt setName:name];
    [self.receipt setCategory:self.categoryCell.value];
    [self.receipt setDate:[NSDate dateWithMilliseconds:_dateMs]];
    [self.receipt setTimeZone:_timeZone];
    [self.receipt setPrice:priceAmount currency:currencyCode];
    [self.receipt setTax:taxAmount];
    [self.receipt setExchangeRate:exchangeRate];
    [self.receipt setComment:self.commentCell.value];
    [self.receipt setExpensable:self.expensableCell.isSwitchOn];
    [self.receipt setFullPage:self.fullPageImageCell.isSwitchOn];
    [self.receipt setPaymentMethod:(PaymentMethod *) self.paymentMethodCell.pickableValue];

    if (self.receipt.objectId == 0) {
        NSString *imageFileName = nil;
        if (self.receiptImage) {
            long long ms = (long long int) ([[NSDate date] timeIntervalSince1970] * 1000LL);
            //TODO jaanus: maybe can use something else here.
            imageFileName = [NSString stringWithFormat:@"%lldx%d.jpg", ms, (int) [self.receiptsViewController receiptsCount]];
            NSString *path = [_trip fileInDirectoryPath:imageFileName];
            if (![WBFileManager forceWriteData:UIImageJPEGRepresentation(self.receiptImage, 0.85) to:path]) {
                imageFileName = nil;
            }

            [self.receipt setImageFileName:imageFileName];
        }
    }

    if ([[Database sharedInstance] saveReceipt:self.receipt]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [EditReceiptViewController showAlertWithTitle:nil message:NSLocalizedString(@"edit.receipt.generic.save.error.message", nil)];
    }
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc]
            initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok", nil) otherButtonTitles:nil] show];
}

- (NSString *)tripCurrency {
    return self.trip.defaultCurrency.code;
}

- (NSString *)receiptCurrency {
    return self.currencyCell.value;
}

- (NSDate *)receiptDate {
    return [NSDate dateWithTimeIntervalSince1970:self.dateMs / 1000.0];
}

@end
