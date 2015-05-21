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

#import "WBImagePicker.h"
#import "TripDistancesViewController.h"
#import "WBCustomization.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Receipts.h"
#import "Database+Trips.h"
#import "Constants.h"

static NSString *CellIdentifier = @"Cell";
static NSString *const PresentTripDistancesSegue = @"PresentTripDistancesSegue";

@interface WBReceiptsViewController ()
{
    WBObservableReceipts *_receipts;
    
    // ugly, but segues are limited
    UIImage *_imageForCreatorSegue;
    WBReceipt *_receiptForCretorSegue;
    
    CGFloat _priceWidth;

    NSString * _lastDateSeparator;
}

@property (nonatomic, strong) WBReceipt *tapped;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;

@end

@implementation WBReceiptsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self setPresentationCellNib:[WBCellWithPriceNameDate viewNib]];
    
    self.dateFormatter = [[WBDateFormatter alloc] init];
    
    if (self.trip == nil) {
        return;
    }
    
    [self updateEditButton];
    [self updateTitle];

    //TODO jaanus: handle this
    //if ([WBBackupHelper isDataBlocked] == false) {
    //    [HUD showUIBlockingIndicatorWithText:@""];
    //    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
    //        NSArray *receipts = [[WBDB receipts] selectAllForTrip:self.trip descending:true];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [_receipts setReceipts:receipts];
    //            [HUD hideUIBlockingIndicator];
    //        });
    //    });
    //}

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tripUpdated:) name:DatabaseDidUpdateModelNotification object:nil];
}

- (void)tripUpdated:(NSNotification *)notification {
    WBTrip *trip = notification.object;
    SRLog(@"updatTrip:%@", trip);

    if (![self.trip isEqual:trip]) {
        return;;
    }

    //TODO jaanus: check posting already altered object
    self.trip = [[Database sharedInstance] tripWithName:self.trip.name];
    [self updateTitle];
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

- (void)updateEditButton {
    self.editButtonItem.enabled = self.numberOfItems > 0;
}

- (void)updateTitle {
    SRLog(@"updateTitle");
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@",
                                                           [self.trip name], [self.trip priceWithCurrencyFormatted]];
}

-(void)updateTrip {
    [self.delegate viewController:self updatedTrip:self.trip];
    [self updateTitle];
}

- (void)updatePricesWidth {
    CGFloat w = [self computePriceWidth];
    if (w == _priceWidth) {
        return;
    }

    _priceWidth = w;
    for (WBCellWithPriceNameDate *cell in self.tableView.visibleCells) {
        [cell.priceWidthConstraint setConstant:w];
        [cell layoutIfNeeded];
    }
}

- (CGFloat)computePriceWidth {
    CGFloat maxWidth = 0;

    for (NSUInteger i = 0; i < [self numberOfItems]; ++i) {
        NSString *str = [[self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] priceWithCurrencyFormatted];

        CGRect bounds = [str boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21]} context:nil];
        maxWidth = MAX(maxWidth, CGRectGetWidth(bounds) + 10);
    }

    maxWidth = MIN(maxWidth, CGRectGetWidth(self.view.bounds) / 2);
    return MAX(CGRectGetWidth(self.view.bounds) / 6, maxWidth);
}

- (void) notifyReceiptRemoved:(WBReceipt*) receipt {
    [_receipts removeReceipt:receipt];
    [self updateTrip];
}

- (NSUInteger)receiptsCount {
    return [self numberOfItems];
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    WBCellWithPriceNameDate *cell = (WBCellWithPriceNameDate *) aCell;

    WBReceipt *receipt = object;

    cell.priceField.text = [receipt priceWithCurrencyFormatted];
    cell.nameField.text = [receipt name];
    cell.dateField.text = [_dateFormatter formattedDate:[receipt date] inTimeZone:[receipt timeZone]];

    [cell.priceWidthConstraint setConstant:_priceWidth];
}

- (void)contentChanged {
    [self updateEditButton];
    [self updatePricesWidth];
}

- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    [[Database sharedInstance] deleteReceipt:object];
}

- (void)swapReceiptAtIndex:(NSUInteger)idx1 withReceiptAtIndex:(NSUInteger)idx2 {
    WBReceipt *rec1 = [self objectAtIndexPath:[NSIndexPath indexPathForRow:idx1 inSection:0]];
    WBReceipt *rec2 = [self objectAtIndexPath:[NSIndexPath indexPathForRow:idx2 inSection:0]];

    if (![[Database sharedInstance] swapReceipt:rec1 withReceipt:rec2]) {
        SRLog(@"Error: cannot swap");
    }
}

- (void)swapUpReceipt:(WBReceipt *)receipt {
    NSUInteger idx = [self indexOfObject:receipt];
    if (idx == 0 || idx == NSNotFound) {
        return;
    }
    [self swapReceiptAtIndex:idx withReceiptAtIndex:(idx - 1)];
}

- (void)swapDownReceipt:(WBReceipt *)receipt {
    NSUInteger idx = [self indexOfObject:receipt];
    if (idx >= ([self numberOfItems] - 1) || idx == NSNotFound) {
        return;
    }
    [self swapReceiptAtIndex:idx withReceiptAtIndex:(idx + 1)];
}

- (BOOL)attachPdfOrImageFile:(NSString *)oldFile toReceipt:(WBReceipt *)receipt {

    NSString *ext = [oldFile pathExtension];

    NSString *imageFileName = [NSString stringWithFormat:@"%tux.%@", [receipt receiptId], ext];
    NSString *newFile = [self.trip fileInDirectoryPath:imageFileName];

    if (![WBFileManager forceCopyFrom:oldFile to:newFile]) {
        NSLog(@"Couldn't copy");
        return NO;
    }

    if (![[Database sharedInstance] updateReceipt:receipt changeFileNameTo:imageFileName]) {
        SRLog(@"Error: cannot update image file");
        return NO;
    }

    return YES;
}

- (BOOL)updateReceipt:(WBReceipt *)receipt image:(UIImage *)image {
    NSString *imageFileName = nil;
    if (image) {
        //TODO jaanus: this leaves old file in documents folder
        imageFileName = [NSString stringWithFormat:@"%tux.jpg", [receipt receiptId]];
        NSString *path = [self.trip fileInDirectoryPath:imageFileName];
        if (![WBFileManager forceWriteData:UIImageJPEGRepresentation(image, 0.85) to:path]) {
            imageFileName = nil;
        }
    }

    if (!imageFileName) {
        return NO;
    }

    if (![[Database sharedInstance] updateReceipt:receipt changeFileNameTo:imageFileName]) {
        SRLog(@"Error: cannot update image file");
        return NO;
    }
    return YES;
}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    [self setTapped:tapped];

    if (self.tableView.editing) {
        [self performSegueWithIdentifier:@"ReceiptCreator" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"ReceiptActions" sender:nil];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReceiptActions"]) {
        WBReceiptActionsViewController *vc = (WBReceiptActionsViewController *) [[segue destinationViewController] topViewController];
        vc.receiptsViewController = self;
        vc.receipt = self.tapped;
    } else if ([[segue identifier] isEqualToString:@"ReceiptCreator"]) {
        EditReceiptViewController *vc = (EditReceiptViewController *) [[segue destinationViewController] topViewController];

        vc.receiptsViewController = self;

        WBReceipt *receipt = nil;
        if (self.tapped) {
            receipt = self.tapped;
        } else {
            [vc setReceiptImage:_imageForCreatorSegue];
            receipt = _receiptForCretorSegue;
            _imageForCreatorSegue = nil;
            _receiptForCretorSegue = nil;
        }
        [vc setReceipt:receipt withTrip:self.trip];
    }
    else if ([[segue identifier] isEqualToString:@"Settings"]) {

    }
    else if ([[segue identifier] isEqualToString:@"GenerateReport"]) {
        WBGenerateViewController *vc = (WBGenerateViewController *) [[segue destinationViewController] topViewController];

        [vc setReceipts:[_receipts receiptsArrayCopy] forTrip:self.trip andViewController:self];
    } else if ([PresentTripDistancesSegue isEqualToString:segue.identifier]) {
        TripDistancesViewController *controller = (TripDistancesViewController *) [[segue destinationViewController] topViewController];
        [controller setTrip:self.trip];
    }

    [self setTapped:nil];
}

-(void)viewController:(EditReceiptViewController *)viewController updatedReceipt:(WBReceipt *)newReceipt fromReceipt:(WBReceipt *)oldReceipt {
    [_receipts replaceReceipt:oldReceipt toReceipt:newReceipt];
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

- (FetchedModelAdapter *)createFetchedModelAdapter {
    // This is needed on iPad. When ap is launched, then storyboard pushes unconfigured view.
    // This is replaced right after by configured one
    if (!self.trip) {
        return nil;
    }

    return [[Database sharedInstance] fetchedReceiptsAdapterForTrip:self.trip];
}

@end
