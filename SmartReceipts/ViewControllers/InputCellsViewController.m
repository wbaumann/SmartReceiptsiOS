//
//  InputCellsViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "InputCellsViewController.h"
#import "InputCellsSection.h"
#import "TextEntryCell.h"
#import "UIView+Search.h"

@interface InputCellsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *presentedSections;
@property (nonatomic, strong) TextEntryCell *lastEntryCell;

@end

@implementation InputCellsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.presentedSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    InputCellsSection *cellsSection = self.presentedSections[section];
    return cellsSection.numberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputCellsSection *section = self.presentedSections[indexPath.section];
    UITableViewCell *cell = [section cellAtIndex:indexPath.row];
    return cell;
}

- (void)addSectionForPresentation:(InputCellsSection *)section {
    if (!self.presentedSections) {
        [self setPresentedSections:[NSMutableArray array]];
    }

    [self.presentedSections addObject:section];
    for (NSUInteger index = 0; index < section.numberOfCells; index++) {
        UITableViewCell *cell = [section cellAtIndex:index];
        if (![cell isKindOfClass:[TextEntryCell class]]) {
            continue;
        }

        TextEntryCell *textEntryCell = (TextEntryCell *) cell;
        [textEntryCell.entryField setDelegate:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITableViewCell *cell = [textField superviewOfType:[UITableViewCell class]];
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    TextEntryCell *nextCell = (TextEntryCell *) [self nextEntryCellAfterIndexPath:cellIndexPath];
    if (nextCell) {
        [nextCell.entryField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (UITableViewCell *)nextEntryCellAfterIndexPath:(NSIndexPath *)indexPath {
    NSUInteger checkedRow = indexPath.row + 1;
    for (NSUInteger section = indexPath.section; section < self.presentedSections.count; section++) {
        InputCellsSection *checked = self.presentedSections[section];
        for (NSUInteger row = checkedRow; row < checked.numberOfCells; row++) {
            UITableViewCell *cell = [checked cellAtIndex:row];
            if ([cell isKindOfClass:[TextEntryCell class]]) {
                return cell;
            }
        }

        checkedRow = 0;
    }
    return nil;
}

@end
