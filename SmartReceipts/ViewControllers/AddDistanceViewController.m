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
#import "CurrencyPickerCell.h"
#import "DatePickerCell.h"

@interface AddDistanceViewController ()

@property (nonatomic, strong) TitledTextEntryCell *distanceCell;
@property (nonatomic, strong) TitledTextEntryCell *rateCell;
@property (nonatomic, strong) CurrencyPickerCell *currencyCell;
@property (nonatomic, strong) TitledTextEntryCell *locationCell;
@property (nonatomic, strong) DatePickerCell *dateCell;

@end

@implementation AddDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Add dictance", nil)];

    [self.tableView registerNib:[TitledTextEntryCell viewNib] forCellReuseIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[CurrencyPickerCell viewNib] forCellReuseIdentifier:[CurrencyPickerCell cellIdentifier]];
    [self.tableView registerNib:[DatePickerCell viewNib] forCellReuseIdentifier:[DatePickerCell cellIdentifier]];

    self.distanceCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.distanceCell setTitle:NSLocalizedString(@"Distance", nil)];

    self.rateCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.rateCell setTitle:NSLocalizedString(@"Rate", nil)];

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[CurrencyPickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"Currency", nil)];

    self.locationCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.locationCell setTitle:NSLocalizedString(@"Location", nil)];

    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:[DatePickerCell cellIdentifier]];
    [self.dateCell setTitle:NSLocalizedString(@"Date", nil)];

    InputCellsSection *section = [InputCellsSection sectionWithCells:@[self.distanceCell, self.rateCell, self.currencyCell, self.locationCell, self.dateCell]];
    [self addSectionForPresentation:section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveDistance {

}

@end
