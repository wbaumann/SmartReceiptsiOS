//
//  AddDistanceViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "AddDistanceViewController.h"
#import "TitledTextEntryCell.h"
#import "UIView+LoadHelpers.h"
#import "UITableViewCell+Identifier.h"
#import "InputCellsSection.h"
#import "InlinedPickerCell.h"
#import "InlinedDatePickerCell.h"
#import "PickerCell.h"
#import "WBTrip.h"
#import "WBPrice.h"
#import "WBCurrency.h"
#import "WBPreferences.h"
#import "WBDateFormatter.h"

@interface AddDistanceViewController ()

@property (nonatomic, strong) TitledTextEntryCell *distanceCell;
@property (nonatomic, strong) TitledTextEntryCell *rateCell;
@property (nonatomic, strong) PickerCell *currencyCell;
@property (nonatomic, strong) InlinedPickerCell *currencyPickerCell;
@property (nonatomic, strong) TitledTextEntryCell *locationCell;
@property (nonatomic, strong) PickerCell *dateCell;
@property (nonatomic, strong) InlinedDatePickerCell *datePickerCell;
@property (nonatomic, strong) TitledTextEntryCell *commentCell;

@end

@implementation AddDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Add dictance", nil)];

    __weak AddDistanceViewController *weakSelf = self;

    [self.tableView registerNib:[TitledTextEntryCell viewNib] forCellReuseIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[PickerCell viewNib] forCellReuseIdentifier:[PickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedPickerCell viewNib] forCellReuseIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedDatePickerCell viewNib] forCellReuseIdentifier:[InlinedDatePickerCell cellIdentifier]];

    self.distanceCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.distanceCell setTitle:NSLocalizedString(@"Distance", nil)];

    self.rateCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.rateCell setTitle:NSLocalizedString(@"Rate", nil)];

    NSString *selectedCurrency = self.trip.price.currency.code;
    if ([MULTI_CURRENCY isEqualToString:selectedCurrency]) {
        selectedCurrency = [WBPreferences defaultCurrency];
    }

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"Currency", nil) value:selectedCurrency];

    self.currencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.currencyPickerCell setAllValues:[WBCurrency allCurrencyCodes]];
    [self.currencyPickerCell setSelectedValue:selectedCurrency];
    [self.currencyPickerCell setValueChangeHandler:^(NSString *selected) {
        [weakSelf.currencyCell setValue:selected];
    }];

    self.locationCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.locationCell setTitle:NSLocalizedString(@"Location", nil)];

    NSDate *date = self.trip.startDate;
    NSTimeZone *timeZone = self.trip.startTimeZone;
    WBDateFormatter *dateFormatter = [[WBDateFormatter alloc] init];

    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.dateCell setTitle:NSLocalizedString(@"Date", nil) value:[dateFormatter formattedDate:date inTimeZone:timeZone]];

    self.datePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];
    [self.datePickerCell setDate:date];
    [self.datePickerCell setChangeHandler:^(NSDate *selected) {
        [weakSelf.dateCell setValue:[dateFormatter formattedDate:selected inTimeZone:timeZone]];
    }];

    self.commentCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.commentCell setTitle:NSLocalizedString(@"Comment", nil)];

    InputCellsSection *section = [InputCellsSection sectionWithCells:@[self.distanceCell, self.rateCell, self.currencyCell, self.locationCell, self.dateCell, self.commentCell]];
    [self addSectionForPresentation:section];

    [self addInlinedPickerCell:self.currencyPickerCell forCell:self.currencyCell];
    [self addInlinedPickerCell:self.datePickerCell forCell:self.self.dateCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveDistance {

}

@end
