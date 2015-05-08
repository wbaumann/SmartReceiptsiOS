//
//  WBReceiptsViewController.m
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceiptsViewController.h"

#import "WBReceiptActionsViewController.h"
#import "WBGenerateViewController.h"

#import "WBDateFormatter.h"
#import "WBFileManager.h"

#import "WBCellWithPriceNameDate.h"

#import "WBDB.h"
#import "WBPreferences.h"

#import "WBTextUtils.h"
#import "WBBackupHelper.h"

#import "HUD.h"

#import "WBAppDelegate.h"
#import "WBImagePicker.h"
#import "TripDistancesViewController.h"

static NSString *CellIdentifier = @"Cell";
static NSString *const PresentTripDistancesSegue = @"PresentTripDistancesSegue";

@interface WBReceiptsViewController ()
{
    WBObservableReceipts *_receipts;
    WBDateFormatter *_dateFormatter;
    
    // ugly, but segues are limited
    UIImage *_imageForCreatorSegue;
    WBReceipt *_receiptForCretorSegue;
    
    CGFloat _priceWidth;
    WBCellWithPriceNameDate * _protoCell;
    
    NSString * _lastDateSeparator;
}
@end

@implementation WBReceiptsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dateFormatter = [[WBDateFormatter alloc] init];
    
    _receipts = [[WBObservableReceipts alloc] init];
    _receipts.delegate = self;
    
    if (self.trip == nil) {
        return;
    }
    
    [self updateEditButton];
    [self updateTitle];
    
    if ([WBBackupHelper isDataBlocked] == false) {
        [HUD showUIBlockingIndicatorWithText:@""];
        dispatch_async([[WBAppDelegate instance] dataQueue], ^{
            NSArray *receipts = [[WBDB receipts] selectAllForTrip:self.trip descending:true];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_receipts setReceipts:receipts];
                [HUD hideUIBlockingIndicator];
            });
        });
    }

    _protoCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_lastDateSeparator && ![[WBPreferences dateSeparator] isEqualToString:_lastDateSeparator]) {
        [self.tableView reloadData];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _lastDateSeparator = [WBPreferences dateSeparator];
}

- (void) updateEditButton {
    self.editButtonItem.enabled = _receipts.count > 0;
}

- (void) updateTitle {
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@",
                                 [self.trip name], [self.trip priceWithCurrencyFormatted]];
}

-(void)updateTrip {
    [self.delegate viewController:self updatedTrip:self.trip];
    [self updateTitle];
}

- (void) updatePricesWidth {
    CGFloat w = [self computePriceWidth];
    if (w == _priceWidth) {
        return;
    }
    
    [self.tableView beginUpdates];
    _priceWidth = w;
    for (WBCellWithPriceNameDate* cell in self.tableView.visibleCells) {
        [cell.priceWidthConstraint setConstant:w];
        [cell layoutIfNeeded];
    }
    [self.tableView endUpdates];
}

- (CGFloat) computePriceWidth {
    CGFloat maxWidth = 0;
    
    UILabel *priceField = _protoCell.priceField;
    
    for (NSUInteger i = 0; i < [_receipts count]; ++i) {
        NSString *str = [[_receipts receiptAtIndex:i] priceWithCurrencyFormatted];
        
        // dumb, but works better than calculating bounds for attributed text because dynamically includes paddings etc.
        priceField.text = str;
        [priceField sizeToFit];
        CGFloat w = priceField.frame.size.width;
        
        if (w > maxWidth) {
            maxWidth = w;
        }
    }
    
    CGSize cellSize = _protoCell.frame.size;
    maxWidth = MIN(maxWidth, cellSize.width / 2);
    return MAX(cellSize.width / 6, maxWidth);
}

- (void) notifyReceiptRemoved:(WBReceipt*) receipt {
    [_receipts removeReceipt:receipt];
    [self updateTrip];
}

- (NSUInteger) receiptsCount {
    return [_receipts count];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_receipts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBCellWithPriceNameDate *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    WBReceipt* receipt = [_receipts receiptAtIndex:(int)indexPath.row];
    
    cell.priceField.text = [receipt priceWithCurrencyFormatted];
    cell.nameField.text = [receipt name];
    cell.dateField.text = [_dateFormatter formattedDate:[receipt dateFromDateMs] inTimeZone:[receipt timeZone]];
    
    [cell.priceWidthConstraint setConstant:_priceWidth];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WBReceipt* receipt = [_receipts receiptAtIndex:(int)indexPath.row];
        if([[WBDB receipts] deleteWithId:[receipt receiptId] forTrip:self.trip]){
            [_receipts removeReceipt:receipt];
            [WBFileManager deleteIfExists:[receipt imageFilePathForTrip:self.trip]];
        }
    }
}


//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void) swapReceiptAtIndex:(int) idx1 withReceiptAtIndex:(int) idx2 {
    WBReceipt *rec1 = [_receipts receiptAtIndex:idx1];
    WBReceipt *rec2 = [_receipts receiptAtIndex:idx2];
    
    if([[WBDB receipts] swapReceipt:rec1 andReceipt:rec2]) {
        [_receipts swapReceiptAtIndex:idx1 withReceiptAtIndex:idx2];
    } else {
        NSLog(@"Error: cannot swap");
    }
}

- (void) swapUpReceipt:(WBReceipt*) receipt {
    NSUInteger idx = [_receipts indexOfReceipt:receipt];
    if (idx == 0 || idx == NSNotFound) {
        return;
    }
    [self swapReceiptAtIndex:(int)idx withReceiptAtIndex:(int)(idx-1)];
}

- (void) swapDownReceipt:(WBReceipt*) receipt {
    NSUInteger idx = [_receipts indexOfReceipt:receipt];
    if (idx >= ([_receipts count]-1) || idx == NSNotFound) {
        return;
    }
    [self swapReceiptAtIndex:(int)idx withReceiptAtIndex:(int)(idx+1)];
}

- (BOOL) attachPdfOrImageFile:(NSString*)oldFile toReceipt:(WBReceipt*) receipt{
    
    NSString *ext = [oldFile pathExtension];
    
    NSString *imageFileName = [NSString stringWithFormat:@"%tx.%@",
                               [receipt receiptId], ext];
    NSString *newFile = [self.trip fileInDirectoryPath:imageFileName];
    
    if (![WBFileManager forceCopyFrom:oldFile to:newFile]) {
        NSLog(@"Couldn't copy");
        return false;
    }
    
    if([[WBDB receipts] updateReceipt:receipt imageFileName:imageFileName]) {
        [receipt setImageFileName:imageFileName];
        // notify change
        [_receipts replaceReceipt:receipt toReceipt:receipt];
    } else {
        NSLog(@"Error: cannot update image file");
        return false;
    }
    
    return true;
}

- (BOOL) updateReceipt:(WBReceipt*) receipt image:(UIImage*) image {
    
    NSString *imageFileName = nil;
    if (image) {
        imageFileName = [NSString stringWithFormat:@"%tx.jpg", [receipt receiptId]];
        NSString *path = [self.trip fileInDirectoryPath:imageFileName];
        if(![WBFileManager forceWriteData:UIImageJPEGRepresentation(image, 0.85) to:path]) {
            imageFileName = nil;
        }
    }
    
    if (!imageFileName) {
        return false;
    }
    
    if([[WBDB receipts] updateReceipt:receipt imageFileName:imageFileName]) {
        [receipt setImageFileName:imageFileName];
        [_receipts replaceReceipt:receipt toReceipt:receipt];
    } else {
        NSLog(@"Error: cannot update image file");
        return false;
    }
    return true;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (tableView.editing) {
        [self performSegueWithIdentifier: @"ReceiptCreator" sender: cell];
    } else {
        [self performSegueWithIdentifier: @"ReceiptActions" sender: cell];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReceiptActions"])
    {
        WBReceiptActionsViewController* vc = (WBReceiptActionsViewController*)[[segue destinationViewController] topViewController];
        
        vc.receiptsViewController = self;
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        if (ip) {
            vc.receipt = [_receipts receiptAtIndex:ip.row];
        }
        
    }
    else if([[segue identifier] isEqualToString:@"ReceiptCreator"])
    {
        WBNewReceiptViewController* vc = (WBNewReceiptViewController*)[[segue destinationViewController] topViewController];
        
        vc.delegate = self;
        vc.receiptsViewController = self;
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        WBReceipt *receipt = nil;
        if (ip && [sender isKindOfClass:[UITableViewCell class]]) {
            receipt = [_receipts receiptAtIndex:(int)ip.row];
        } else {
            [vc setReceiptImage:_imageForCreatorSegue];
            receipt = _receiptForCretorSegue;
            _imageForCreatorSegue = nil;
            _receiptForCretorSegue = nil;
        }
        [vc setReceipt:receipt withTrip:self.trip];
    }
    else if([[segue identifier] isEqualToString:@"Settings"])
    {
        
    }
    else if([[segue identifier] isEqualToString:@"GenerateReport"]) {
        WBGenerateViewController* vc = (WBGenerateViewController*)[[segue destinationViewController] topViewController];
        
        [vc setReceipts:[_receipts receiptsArrayCopy] forTrip:self.trip andViewController:self];
    } else if ([PresentTripDistancesSegue isEqualToString:segue.identifier]) {
        TripDistancesViewController *controller = (TripDistancesViewController *) [[segue destinationViewController] topViewController];
        [controller setTrip:self.trip];
    }
}

#pragma mark - WBNewReceiptViewControllerDelegate

-(void)viewController:(WBNewReceiptViewController *)viewController newReceipt:(WBReceipt *)receipt {
    // We start our updates here for new Receipts, since ios8 checks the table size at different time than ios7
    [self.tableView beginUpdates];
    [_receipts addReceipt:receipt];
}

-(void)viewController:(WBNewReceiptViewController *)viewController updatedReceipt:(WBReceipt *)newReceipt fromReceipt:(WBReceipt *)oldReceipt {
    [_receipts replaceReceipt:oldReceipt toReceipt:newReceipt];
}

#pragma mark - WBObservableTripsDelegate

-(void)observableReceipts:(WBObservableReceipts *)observableReceipts filledWithReceipts:(NSArray *)receipts {
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    if (ip) {
        [self.tableView deselectRowAtIndexPath:ip animated:YES];
    }
    
    [self.tableView reloadData];
    [self updateEditButton];
    [self updatePricesWidth];
}

-(void)observableReceipts:(WBObservableReceipts *)observableReceipts addedReceipt:(WBReceipt *)receipt atIndex:(int)index {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    // [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    
    [self updateTrip];
    [self updateEditButton];
    [self updatePricesWidth];
}

-(void)observableReceipts:(WBObservableReceipts *)observableReceipts replacedReceipt:(WBReceipt *)oldReceipt toReceipt:(WBReceipt *)newReceipt fromIndex:(int)oldIndex toIndex:(int)newIndex {
    
    [self.tableView beginUpdates];
    
    if (oldIndex == newIndex) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:oldIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
    
    [self updateTrip];
    [self updatePricesWidth];
}

-(void)observableReceipts:(WBObservableReceipts *)observableReceipts removedReceipt:(WBReceipt *)receipt atIndex:(int)index {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self updateTrip];
    [self updateEditButton];
    [self updatePricesWidth];
}

-(void)observableReceipts:(WBObservableReceipts *)observableReceipts swappedReceiptAtIndex:(int)idx1 withReceiptAtIndex:(int)idx2 {
    [self.tableView beginUpdates];
    [self.tableView
     reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx1 inSection:0],[NSIndexPath indexPathForRow:idx2 inSection:0]]
     withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self updatePricesWidth];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex!=1) {
        return;
    }
    NSString *text = [[alertView textFieldAtIndex:0] text];
    double miles = self.trip.miles + [text doubleValue];
    [[WBDB trips] updateTrip:self.trip miles:miles];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return [WBTextUtils isMoney:newText];
}

- (IBAction)actionCamera:(id)sender {
    [[WBImagePicker sharedInstance] presentPickerOnController:self completion:^(UIImage *image) {
        if (!image) {
            return;
        }

        _imageForCreatorSegue = image;
        _receiptForCretorSegue = nil;
        [self performSegueWithIdentifier:@"ReceiptCreator" sender:self];
    }];
}

@end
