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
#import "WBPreferences.h"
#import "ImagePicker.h"
#import "TripDistancesViewController.h"
#import "WBCustomization.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Receipts.h"
#import "Database+Trips.h"
#import "Constants.h"
#import "ReceiptSummaryCell.h"
#import "SmartReceipts-Swift.h"

static NSString *CellIdentifier = @"Cell";
static NSString *const PresentTripDistancesSegue = @"PresentTripDistancesSegue";

@interface WBReceiptsViewController ()
{
    // ugly, but segues are limited
    UIImage *_imageForCreatorSegue;
    WBReceipt *_receiptForCretorSegue;
    
    CGFloat _priceWidth;
}

@property (nonatomic, strong) WBReceipt *tapped;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL showReceiptDate;
@property (nonatomic, assign) BOOL showReceiptCategory;
@property (nonatomic, copy) NSString *lastDateSeparator;
@property (nonatomic, assign) BOOL showAttachmentMarker;

@end

@implementation WBReceiptsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //clear when new tip is opened
    [[WBReceiptsViewController sharedInputCache] setDictionary:@{}];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setShowReceiptDate:[WBPreferences layoutShowReceiptDate]];
    [self setShowReceiptCategory:[WBPreferences layoutShowReceiptCategory]];
    [self setShowAttachmentMarker:[WBPreferences layoutShowReceiptAttachmentMarker]];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self setPresentationCellNib:[ReceiptSummaryCell viewNib]];
    
    self.dateFormatter = [[WBDateFormatter alloc] init];
    
    if (self.trip == nil) {
        return;
    }
    
    [self updateEditButton];
    [self updateTitle];
    [self setLastDateSeparator:[WBPreferences dateSeparator]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tripUpdated:) name:DatabaseDidUpdateModelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsSaved) name:SmartReceiptsSettingsSavedNotification object:nil];
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

- (void)updateEditButton {
    self.editButtonItem.enabled = self.numberOfItems > 0;
}

- (void)updateTitle {
    SRLog(@"updateTitle");
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@",
                                                           [self.trip name], [self.trip formattedPrice]];
}

- (void)updatePricesWidth {
    CGFloat w = [self computePriceWidth];
    if (w == _priceWidth) {
        return;
    }

    _priceWidth = w;
    for (ReceiptSummaryCell *cell in self.tableView.visibleCells) {
        [cell.priceWidthConstraint setConstant:w];
        [cell layoutIfNeeded];
    }
}

- (CGFloat)computePriceWidth {
    CGFloat maxWidth = 0;

    for (NSUInteger i = 0; i < [self numberOfItems]; ++i) {
        WBReceipt *receipt = [self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSString *str = [receipt formattedPrice];

        CGRect bounds = [str boundingRectWithSize:CGSizeMake(1000, 100) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:21]} context:nil];
        maxWidth = MAX(maxWidth, CGRectGetWidth(bounds) + 10);
    }

    maxWidth = MIN(maxWidth, CGRectGetWidth(self.view.bounds) / 2);
    return MAX(CGRectGetWidth(self.view.bounds) / 6, maxWidth);
}

- (NSUInteger)receiptsCount {
    return [self numberOfItems];
}

- (void)configureCell:(UITableViewCell *)aCell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    ReceiptSummaryCell *cell = (ReceiptSummaryCell *) aCell;

    WBReceipt *receipt = object;

    cell.priceField.text = [receipt formattedPrice];
    cell.nameField.text = [receipt name];
    cell.dateField.text = self.showReceiptDate ? [_dateFormatter formattedDate:[receipt date] inTimeZone:[receipt timeZone]] : @"";
    cell.categoryLabel.text = self.showReceiptCategory ? receipt.category : @"";
    cell.markerLabel.text = self.showAttachmentMarker ? [receipt attachmentMarker] : @"";

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

    NSString *imageFileName = [NSString stringWithFormat:@"%tu_%@.%@", [receipt receiptId], [receipt name], ext];
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
        imageFileName = [NSString stringWithFormat:@"%tu_%@.jpg", [receipt receiptId], [receipt name]];
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
        [vc setTrip:self.trip];
    } else if ([PresentTripDistancesSegue isEqualToString:segue.identifier]) {
        TripDistancesViewController *controller = (TripDistancesViewController *) [[segue destinationViewController] topViewController];
        [controller setTrip:self.trip];
    }

    [self setTapped:nil];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (IBAction)actionCamera:(id)sender {
    [[ImagePicker sharedInstance] presentPickerOnController:self completion:^(UIImage *image) {
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

- (void)settingsSaved {
    if (self.showReceiptDate == [WBPreferences layoutShowReceiptDate]
            && self.showReceiptCategory == [WBPreferences layoutShowReceiptCategory]
            && self.showAttachmentMarker == [WBPreferences layoutShowReceiptAttachmentMarker]
            && [self.lastDateSeparator isEqualToString:[WBPreferences dateSeparator]]) {
        return;
    }

    [self setLastDateSeparator:[WBPreferences dateSeparator]];
    [self setShowReceiptDate:[WBPreferences layoutShowReceiptDate]];
    [self setShowReceiptCategory:[WBPreferences layoutShowReceiptCategory]];
    [self setShowAttachmentMarker:[WBPreferences layoutShowReceiptAttachmentMarker]];
    [self.tableView reloadData];
}

+ (NSMutableDictionary *)sharedInputCache {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [NSMutableDictionary dictionary];
    });
}

@end
