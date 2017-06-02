//
//  EditDistanceViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "EditDistanceViewController.h"
#import "TitledTextEntryCell.h"
#import "UIView+LoadHelpers.h"
#import "UITableViewCell+Identifier.h"
#import "InputCellsSection.h"
#import "InlinedPickerCell.h"
#import "InlinedDatePickerCell.h"
#import "Distance.h"
#import "PickerCell.h"
#import "WBTrip.h"
#import "Price.h"
#import "WBPreferences.h"
#import "WBDateFormatter.h"
#import "NSString+Validation.h"
#import "NSMutableString+Issues.h"
#import "UIAlertView+Blocks.h"
#import "NSDecimalNumber+WBNumberParse.h"
#import "Database.h"
#import "Database+Distances.h"
#import "StringPickableWrapper.h"
#import "Constants.h"
#import "WBReceiptsViewController.h"
#import "SmartReceipts-Swift.h"

NSString *const SREditDistanceDateCacheKey = @"SREditDistanceDateCacheKey";

@interface EditDistanceViewController ()

@property (nonatomic, strong) TitledTextEntryCell *distanceCell;
@property (nonatomic, strong) TitledTextEntryCell *rateCell;
@property (nonatomic, strong) PickerCell *currencyCell;
@property (nonatomic, strong) InlinedPickerCell *currencyPickerCell;
@property (nonatomic, strong) TitledTextEntryCell *locationCell;
@property (nonatomic, strong) PickerCell *dateCell;
@property (nonatomic, strong) InlinedDatePickerCell *datePickerCell;
@property (nonatomic, strong) TitledTextEntryCell *commentCell;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;

@end

@implementation EditDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.distance) {
        [self.navigationItem setTitle:NSLocalizedString(@"edit.distance.controller.edit.title", nil)];
    } else {
        [self.navigationItem setTitle:NSLocalizedString(@"edit.distance.controller.add.title", nil)];
    }

    __weak EditDistanceViewController *weakSelf = self;

    [self.tableView registerNib:[TitledTextEntryCell viewNib] forCellReuseIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[PickerCell viewNib] forCellReuseIdentifier:[PickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedPickerCell viewNib] forCellReuseIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedDatePickerCell viewNib] forCellReuseIdentifier:[InlinedDatePickerCell cellIdentifier]];

    self.distanceCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.distanceCell setTitle:NSLocalizedString(@"edit.distance.controller.distance.label", nil)];
    [self.distanceCell activateDecimalEntryMode];

    self.rateCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.rateCell setTitle:NSLocalizedString(@"edit.distance.controller.rate.label", nil)];
    [self.rateCell activateDecimalEntryModeWithDecimalPlaces:SmartReceiptsNumberOfDecimalPlacesForGasRate];

    NSString *selectedCurrency = [self.trip.defaultCurrency code];

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"edit.distance.controller.currency.label", nil) value:selectedCurrency];

    self.currencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    NSArray *cachedCurrencyCodes = [[RecentCurrenciesCache shared] cachedCurrencyCodes];
    [self.currencyPickerCell setAllValues:[cachedCurrencyCodes arrayByAddingObjectsFromArray:[Currency allCurrencyCodes]]];
    [self.currencyPickerCell setSelectedValue:[StringPickableWrapper wrapValue:selectedCurrency]];
    [self.currencyPickerCell setValueChangeHandler:^(id<Pickable> selected) {
        [weakSelf.currencyCell setValue:selected.presentedValue];
    }];

    self.locationCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.locationCell setTitle:NSLocalizedString(@"edit.distance.controller.location.label", nil)];
    [self.locationCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    NSDate *date = [WBReceiptsViewController sharedInputCache][SREditDistanceDateCacheKey];
    if (!date) {
        date = self.trip.startDate;
    }
    NSTimeZone *timeZone = self.trip.startTimeZone;
    self.dateFormatter = [[WBDateFormatter alloc] init];

    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.dateCell setTitle:NSLocalizedString(@"edit.distance.controller.date.label", nil) value:[self.dateFormatter formattedDate:date inTimeZone:timeZone]];

    self.datePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.datePickerCell setDate:date];
    [self.datePickerCell setChangeHandler:^(NSDate *selected) {
        [WBReceiptsViewController sharedInputCache][SREditDistanceDateCacheKey] = selected;

        [weakSelf.dateCell setValue:[weakSelf.dateFormatter formattedDate:selected inTimeZone:timeZone]];

        if ([weakSelf.trip dateOutsideTripBounds:selected]) {
            [weakSelf.dateCell addWarningWithTitle:NSLocalizedString(@"edit.distance.date.range.warning.title", nil)
                                           message:NSLocalizedString(@"edit.distance.date.range.warning.message", nil)];
        } else {
            [weakSelf.dateCell removeWarning];
        }
    }];

    if (![WBPreferences allowDataEntryOutsideTripBounds]) {
        [self.datePickerCell setMinDate:self.trip.startDate maxDate:self.trip.endDate];
    }

    self.commentCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.commentCell setTitle:NSLocalizedString(@"edit.distance.controller.comment.label", nil)];
    [self.commentCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    InputCellsSection *section = [InputCellsSection sectionWithCells:@[self.distanceCell, self.rateCell, self.currencyCell, self.locationCell, self.dateCell, self.commentCell]];
    [self addSectionForPresentation:section];

    [self addInlinedPickerCell:self.currencyPickerCell forCell:self.currencyCell];
    [self addInlinedPickerCell:self.datePickerCell forCell:self.self.dateCell];

    [self loadExistingValues];
}

- (void)loadExistingValues {
    double rateDefaultValue = [WBPreferences distanceRateDefaultValue];

    if (rateDefaultValue > 0.0001) {
        [self.rateCell setValue:[NSNumberFormatter formatDouble:rateDefaultValue decimalPlaces:SmartReceiptsNumberOfDecimalPlacesForGasRate]];
    }

    if (!self.distance) {
        return;
    }

    [self.distanceCell setValue:[self.distance.distance descriptionWithLocale:[NSLocale currentLocale]]];
    [self.rateCell setValue:[self.distance.rate mileageRateAmountAsString]];
    NSString *currency = self.distance.rate.currency.code;
    [self.currencyCell setValue:currency];
    [self.currencyPickerCell setSelectedValue:[StringPickableWrapper wrapValue:currency]];
    [self.locationCell setValue:self.distance.location];
    [self.dateCell setValue:[self.dateFormatter formattedDate:self.distance.date inTimeZone:self.distance.timeZone]];
    [self.datePickerCell setDate:self.distance.date];
    [self.commentCell setValue:self.distance.comment];
}

- (IBAction)saveDistance {
    NSString *issues = [self validateInput];
    if (issues.hasValue) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"edit.distance.controller.validation.error.title", nil)
                                                            message:issues
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                                   otherButtonItems:nil];
        [alertView show];
        return;
    }

    if (!self.distance) {
        // We're inserting a new one
        [[AnalyticsManager sharedManager] recordWithEvent:[Event distancePersistNewDistance]];
        self.distance = [[Distance alloc] init];
        [self.distance setTrip:self.trip];
    } else {
        // We're updating
        [[AnalyticsManager sharedManager] recordWithEvent:[Event distancePersistUpdateDistance]];
    }

    NSDecimalNumber *distance = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.distanceCell.value];
    NSDecimalNumber *rate = [NSDecimalNumber decimalNumberOrZeroUsingCurrentLocale:self.rateCell.value];
    NSString *currency = self.currencyCell.value;
    NSString *location = self.locationCell.value;
    NSDate *date = self.datePickerCell.value;
    NSString *comment = self.commentCell.value;

    [self.distance setDistance:distance];
    [self.distance setRate:[Price priceWithAmount:rate currencyCode:currency]];
    [self.distance setLocation:location];
    [self.distance setDate:date];
    [self.distance setTimeZone:self.trip.startTimeZone];
    [self.distance setComment:comment];

    if ([[Database sharedInstance] saveDistance:self.distance]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"edit.distance.controller.save.distance.error.title", nil)
                                                            message:NSLocalizedString(@"edit.distance.controller.save.distance.error.generic.message", nil)
                                                   cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"generic.button.title.ok", nil)]
                                                   otherButtonItems:nil];
        [alertView show];
    }
}

- (NSString *)validateInput {
    NSMutableString *issues = [NSMutableString string];
    if (![[self.distanceCell value] hasValue]) {
        [issues appendIssue:NSLocalizedString(@"edit.distance.controller.validation.distance.missing", nil)];
    }

    if (![self.rateCell value].hasValue) {
        [issues appendIssue:NSLocalizedString(@"edit.distance.controller.validation.rate.missing", nil)];
    }

    return [NSString stringWithString:issues];
}

@end
