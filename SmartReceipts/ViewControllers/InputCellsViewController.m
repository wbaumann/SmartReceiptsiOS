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
#import "Constants.h"
#import "InputValidation.h"
#import "WBAutocompleteHelper.h"
#import "TitledAutocompleteEntryCell.h"
#import "SwitchControlCell.h"
#import "UIApplication+DismissKeyboard.h"

@interface InputCellsViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *presentedSections;
@property (nonatomic, strong) TextEntryCell *lastEntryCell;
@property (nonatomic, strong) NSMutableDictionary *inlinedPickers;
@property (nonatomic, strong) NSIndexPath *presentingPickerForIndexPath;
@property (nonatomic, strong) id<InputValidation> activeFieldInputValidation;

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
        [textEntryCell.entryField setReturnKeyType:UIReturnKeyNext];
    }
}

- (void)addInlinedPickerCell:(UITableViewCell *)cell forCell:(UITableViewCell *)forCell {
    NSIndexPath *indexPath = [self indexPathForCell:forCell];
    SRAssert(indexPath);

    if (!self.inlinedPickers) {
        [self setInlinedPickers:[NSMutableDictionary dictionary]];
    }

    self.inlinedPickers[indexPath] = cell;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    for (NSUInteger section = 0; section < self.presentedSections.count; section++) {
        InputCellsSection *cellsSection = self.presentedSections[section];
        for (NSUInteger row = 0; row < cellsSection.numberOfCells; row++) {
            UITableViewCell *checked = [cellsSection cellAtIndex:row];
            if (cell == checked) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }

    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITableViewCell *cell = [textField superviewOfType:[UITableViewCell class]];
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    TextEntryCell *nextCell = (TextEntryCell *) [self nextEntryCellAfterIndexPath:cellIndexPath];
    if (nextCell) {
        NSIndexPath *indexPath = [self indexPathForCell:nextCell];
        [nextCell.entryField becomeFirstResponder];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = [textField superviewOfType:[UITableViewCell class]];

    if (![cell isKindOfClass:[TitledAutocompleteEntryCell class]]) {
        return;
    }

    TitledAutocompleteEntryCell *autocompleteEntryCell = (TitledAutocompleteEntryCell *) cell;
    [autocompleteEntryCell.autocompleteHelper textFieldDidEndEditing:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = [textField superviewOfType:[UITableViewCell class]];

    if ([cell isKindOfClass:[TitledAutocompleteEntryCell class]]) {
        TitledAutocompleteEntryCell *autocompleteEntryCell = (TitledAutocompleteEntryCell *) cell;
        [autocompleteEntryCell.autocompleteHelper textFieldDidBeginEditing:textField];
    }

    if (![cell isKindOfClass:[TextEntryCell class]]) {
        [self setActiveFieldInputValidation:nil];
        return;
    }

    TextEntryCell *textEntryCell = (TextEntryCell *) cell;
    [self setActiveFieldInputValidation:textEntryCell.inputValidation];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *validate = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (!self.activeFieldInputValidation) {
        return YES;
    }

    if (string.length == 0) {
        //always allow deletes
        return YES;
    }

    return [self.activeFieldInputValidation isValidInput:validate];
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

        if (self.containNextEditSearchInsideSection) {
            break;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self hasInlinedPickerAttachedAtIndexPath:indexPath]) {
        [self handleInlinePickerForIndexPath:indexPath];
        return;
    }

    UITableViewCell *cell = [self cellAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TextEntryCell class]]) {
        TextEntryCell *entryCell = (TextEntryCell *) cell;
        [entryCell.entryField becomeFirstResponder];
    } else if ([cell isKindOfClass:[SwitchControlCell class]]) {
        SwitchControlCell *switchCell = (SwitchControlCell *) cell;
        [switchCell setSwitchOn:!switchCell.isSwitchOn animated:YES];
    } else {
        [self tappedCell:cell atIndexPath:indexPath];
    }
}

- (void)tappedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SRLog(@"tappedCell:atIndexPath:%@", indexPath);
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    InputCellsSection *section = self.presentedSections[indexPath.section];
    return [section cellAtIndex:indexPath.row];
}

- (void)handleInlinePickerForIndexPath:(NSIndexPath *)indexPath {
    [self.tableView beginUpdates];

    NSIndexPath *handled = [self indexPathWithoutPossiblePickerOffset:indexPath];

    NSIndexPath *previous = self.presentingPickerForIndexPath;
    if (previous) {
        [self dismissPickerForIndexPath:previous];
    }

    if (![handled isEqual:previous]) {
        [self presentPickerForIndexPath:handled];
    }

    [self.tableView endUpdates];
}

- (void)presentPickerForIndexPath:(NSIndexPath *)indexPath {
    [UIApplication dismissKeyboard];
    UITableViewCell *pickerCell = self.inlinedPickers[indexPath];
    NSIndexPath *insertPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    InputCellsSection *section = self.presentedSections[insertPath.section];
    [section insertCell:pickerCell atIndex:insertPath.row];

    [self.tableView insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationFade];

    [self setPresentingPickerForIndexPath:indexPath];
}

- (void)dismissPickerForIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *removePath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    InputCellsSection *section = self.presentedSections[removePath.section];
    [section removeCellAtIndex:removePath.row];

    [self.tableView deleteRowsAtIndexPaths:@[removePath] withRowAnimation:UITableViewRowAnimationFade];

    [self setPresentingPickerForIndexPath:nil];
}

- (BOOL)hasInlinedPickerAttachedAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *checked = [self indexPathWithoutPossiblePickerOffset:indexPath];
    return self.inlinedPickers[checked] != nil;
}

- (NSIndexPath *)indexPathWithoutPossiblePickerOffset:(NSIndexPath *)indexPath {
    if (!self.presentingPickerForIndexPath || self.presentingPickerForIndexPath.section != indexPath.section || self.presentingPickerForIndexPath.row >= indexPath.row) {
        return indexPath;
    }

    return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    InputCellsSection *cellsSection = self.presentedSections[section];
    return [cellsSection sectionTitle];
}

@end
