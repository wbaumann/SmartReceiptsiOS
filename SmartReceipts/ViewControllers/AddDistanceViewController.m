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

@interface AddDistanceViewController ()

@property (nonatomic, strong) TitledTextEntryCell *distanceCell;
@property (nonatomic, strong) TitledTextEntryCell *rateCell;
@property (nonatomic, strong) PickerCell *currencyCell;
@property (nonatomic, strong) InlinedPickerCell *currencyPickerCell;
@property (nonatomic, strong) TitledTextEntryCell *locationCell;
@property (nonatomic, strong) PickerCell *dateCell;
@property (nonatomic, strong) InlinedDatePickerCell *datePickerCell;

@end

@implementation AddDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Add dictance", nil)];

    [self.tableView registerNib:[TitledTextEntryCell viewNib] forCellReuseIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.tableView registerNib:[PickerCell viewNib] forCellReuseIdentifier:[PickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedPickerCell viewNib] forCellReuseIdentifier:[InlinedPickerCell cellIdentifier]];
    [self.tableView registerNib:[InlinedDatePickerCell viewNib] forCellReuseIdentifier:[InlinedDatePickerCell cellIdentifier]];

    self.distanceCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.distanceCell setTitle:NSLocalizedString(@"Distance", nil)];

    self.rateCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.rateCell setTitle:NSLocalizedString(@"Rate", nil)];

    self.currencyCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.currencyCell setTitle:NSLocalizedString(@"Currency", nil)];

    self.currencyPickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedPickerCell cellIdentifier]];

    self.locationCell = [self.tableView dequeueReusableCellWithIdentifier:[TitledTextEntryCell cellIdentifier]];
    [self.locationCell setTitle:NSLocalizedString(@"Location", nil)];

    self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:[PickerCell cellIdentifier]];
    [self.dateCell setTitle:NSLocalizedString(@"Date", nil)];

    self.datePickerCell = [self.tableView dequeueReusableCellWithIdentifier:[InlinedDatePickerCell cellIdentifier]];

    InputCellsSection *section = [InputCellsSection sectionWithCells:@[self.distanceCell, self.rateCell, self.currencyCell, self.locationCell, self.dateCell]];
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
