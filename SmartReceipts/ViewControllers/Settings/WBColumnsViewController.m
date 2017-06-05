//
//  WBColumnsViewController.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBColumnsViewController.h"

#import "ReceiptColumn.h"
#import "Database.h"
#import "Database+CSVColumns.h"
#import "Database+PDFColumns.h"

@interface WBColumnsViewController () {
    WBDynamicPicker *_dynamicPicker;

    NSArray *_columnsNames;
    NSMutableArray *_columns;

    BOOL _changed;
}

@end

@implementation WBColumnsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _columnsNames = [ReceiptColumn availableColumnsNames];
    NSArray *columns = self.forCSV ? [[Database sharedInstance] allCSVColumns] : [[Database sharedInstance] allPDFColumns];
    _columns = columns.mutableCopy;
    _changed = NO;

    self.navigationItem.title = self.forCSV
            ? NSLocalizedString(@"columns.controller.title.csv", nil)
            : NSLocalizedString(@"columns.controller.title.pdf", nil);

    _dynamicPicker = [[WBDynamicPicker alloc] initWithType:WBDynamicPickerTypePicker withController:self];
    [_dynamicPicker setTitle:NSLocalizedString(@"columns.controller.picker.title", nil)];
    _dynamicPicker.delegate = self;

    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.editButtonItem];
    
    [AppTheme customizeOnViewDidLoad:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        if (_changed) {
            Database *database = [Database sharedInstance];
            LOGGER_INFO(@"Saving columns. Result: %d", (self.forCSV ? [database replaceAllCSVColumnsWith:_columns] : [database replaceAllPDFColumnsWith:_columns]));
            _changed = NO;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_columns count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Column *col = _columns[indexPath.row];

    NSString *colPrefix = NSLocalizedString(@"columns.controller.column.prefix", @"Column prefix used while ordering");

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %d", colPrefix, (int) (indexPath.row + 1)];
    cell.detailTextLabel.text = [col name];

    return cell;
}

- (void)refreshCellsInTableView:(UITableView *)tableView fromIndex:(NSUInteger)idx1 toIndex:(NSUInteger)idx2 changeIndex:(NSInteger)change {
    if (idx2 < idx1) {
        NSUInteger tmp = idx1;
        idx1 = idx2;
        idx2 = tmp;
    }

    if (idx2 >= _columns.count) {
        idx2 = _columns.count - 1;
    }

    NSString *colPrefix = NSLocalizedString(@"columns.controller.column.prefix", @"Column prefix used while ordering");

    for (NSUInteger i = idx1; i <= idx2; ++i) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %td", colPrefix, (i + 1 + change)];

        Column *col = _columns[i];
        cell.detailTextLabel.text = [col name];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_columns removeObjectAtIndex:indexPath.row];
        _changed = YES;

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshCellsInTableView:tableView fromIndex:indexPath.row toIndex:(_columns.count - 1) changeIndex:0];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSInteger idx1 = fromIndexPath.row;
    NSInteger idx2 = toIndexPath.row;

    if (idx1 == idx2) {
        return;
    }

    NSString *colPrefix = NSLocalizedString(@"columns.controller.column.prefix", @"Column prefix used while ordering");

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx1 inSection:0]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %td", colPrefix, (idx2 + 1)];

    if (idx1 < idx2) {
        [self refreshCellsInTableView:tableView fromIndex:(idx1 + 1) toIndex:idx2 changeIndex:(-1)];
    } else {
        [self refreshCellsInTableView:tableView fromIndex:idx2 toIndex:(idx1 - 1) changeIndex:(+1)];
    }

    Column *col = [_columns objectAtIndex:idx1];
    [_columns removeObjectAtIndex:idx1];
    [_columns insertObject:col atIndex:idx2];
    _changed = YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.columnsTableView setEditing:editing animated:animated];
}

- (NSString *)dynamicPicker:(WBDynamicPicker *)dynamicPicker titleForRow:(NSInteger)row {
    return [_columnsNames objectAtIndex:row];
}

- (NSInteger)dynamicPickerNumberOfRows:(WBDynamicPicker *)dynamicPicker {
    return _columnsNames.count;
}

- (void)dynamicPicker:(WBDynamicPicker *)dynamicPicker doneWith:(id)subject {
    NSString *columnName = [_columnsNames objectAtIndex:[dynamicPicker selectedRow]];
    int idx = (int) _columns.count;
    [_columns addObject:[[Column alloc] initWithIndex:0 name:columnName]];
    _changed = YES;

    [self.columnsTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)actionAdd:(id)sender {
    [_dynamicPicker showFromBarButtonItem:self.navigationItem.rightBarButtonItem];
}
@end
