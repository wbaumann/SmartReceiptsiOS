//
//  WBReceiptActionsViewController.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBReceiptActionsViewController.h"

#import "WBMoveCopyReceiptViewController.h"

#import "WBImageViewController.h"

#import "WBAppDelegate.h"
#import "ImagePicker.h"

#import "SmartReceipts-Swift.h"

@interface WBReceiptActionsViewController ()

@property UIDocumentInteractionController *documentInteractionController;

@end

@implementation WBReceiptActionsViewController
{
    int _imgType;
    NSArray *_cellsTexts;
    NSArray *_cellsIds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = [self.receipt name];
    
    [self createCellsTextsAndIndices];
    [AppTheme customizeOnViewDidLoad:self];
}

-(void)createCellsTextsAndIndices {
    
    if ([self.receipt hasImage]) {
        _imgType = 1;
    } else if ([self.receipt hasPDF]) {
        _imgType = 2;
    } else {
        _imgType = 0;
    }
    
    NSMutableArray *cellsIds=[NSMutableArray new], *cellsTexts=[NSMutableArray new];
    
    if ([self filePathToAttach]) {
        
        NSString *str;
        
        switch (_imgType) {
            case 1:
                if ([[WBAppDelegate instance] isFileImage]) {
                    str = NSLocalizedString(@"receipt.action.replace.image", nil);
                } else {
                    str = NSLocalizedString(@"receipt.action.replace.image.with.pdf", nil);
                }
                break;
                
            case 2:
                if ([[WBAppDelegate instance] isFileImage]) {
                    str = NSLocalizedString(@"receipt.action.replace.pdf.with.image", nil);
                } else {
                    str = NSLocalizedString(@"receipt.action.replace.pdf", nil);
                }
                break;
                
            default:
                if ([[WBAppDelegate instance] isFileImage]) {
                    str = NSLocalizedString(@"receipt.action.attach.image", nil);
                } else {
                    str = NSLocalizedString(@"receipt.action.attach.pdf", nil);
                }
                break;
        }
        
        [cellsIds addObject:@0];
        [cellsTexts addObject:str];
    }
    
    if (_imgType == 1) {
        [cellsIds addObject:@1];
        [cellsTexts addObject:NSLocalizedString(@"receipt.action.view.receipt.image", nil)];
    } else if (_imgType == 2) {
        [cellsIds addObject:@1];
        [cellsTexts addObject:NSLocalizedString(@"receipt.action.view.receipt.pdf", nil)];
    }
    
    [cellsIds addObject:@2];
    [cellsTexts addObject:
     (_imgType > 0 ? NSLocalizedString(@"receipt.action.retake.receipt.image", nil) : NSLocalizedString(@"receipt.action.take.receipt.image", nil))];
    
    [cellsIds addObject:@3];
    [cellsTexts addObject:NSLocalizedString(@"receipt.action.move", nil)];
    
    [cellsIds addObject:@4];
    [cellsTexts addObject:NSLocalizedString(@"receipt.action.copy", nil)];
    
    [cellsIds addObject:@5];
    [cellsTexts addObject:NSLocalizedString(@"receipt.action.swap.up", nil)];
    
    [cellsIds addObject:@6];
    [cellsTexts addObject:NSLocalizedString(@"receipt.action.swap.down", nil)];
    
    _cellsIds = cellsIds.copy;
    _cellsTexts = cellsTexts.copy;
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createCellsTextsAndIndices];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    // it should give detail nav on iPad and main nav on iPhone
    return self.receiptsViewController.navigationController;
}

- (void)emailPDF{
    
}

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:[self.receipt imageFilePathForTrip:self.receiptsViewController.trip]];
    
    return URL;
}

- (void)showDocumentImage {
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:[self.receipt imageFilePathForTrip:self.receiptsViewController.trip]];
    
    if (URL) {
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        [self.documentInteractionController setDelegate:self];
        self.documentInteractionController.name = [self.receipt name];
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = [((NSNumber*)[_cellsIds objectAtIndex:indexPath.row]) intValue];
    
    switch (index) {
        case 0:
            // attach / replace pdf or image
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsImportPictureReceipt]];
            
            [self.receiptsViewController attachPdfOrImageFile:[self filePathToAttach] toReceipt:self.receipt];
            [[WBAppDelegate instance] freeFilePathToAttach];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
        case 1: {
            // view receipt image
            
            if (_imgType == 1) { // image
                
                [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuViewImage]];
                [self performSegueWithIdentifier: @"Image" sender: self];
            } else { // pdf
                [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuViewPdf]];
                [self dismissViewControllerAnimated:YES completion:^{
                    [self showDocumentImage];
                }];
            }
            
            break;
        }
        case 2: {
            // take / replace receipt image
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuRetakePhoto]];
            [self takePhoto];
            break;
        }
        case 3:
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuMoveCopy]];
            [self performSegueWithIdentifier: @"Move" sender: self];
            break;
            
        case 4:
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuMoveCopy]];
            [self performSegueWithIdentifier: @"Copy" sender: self];
            break;
            
        case 5:
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuSwapUp]];
            [self.receiptsViewController swapUpReceipt:self.receipt];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case 6:
            [[AnalyticsManager sharedManager] recordWithEvent:[Event receiptsReceiptMenuSwapDown]];
            [self.receiptsViewController swapDownReceipt:self.receipt];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)takePhoto {
    [[ImagePicker sharedInstance] presentPickerOnController:self completion:^(UIImage *image) {
        if (!image) {
            return;
        }

        [self.receiptsViewController updateReceipt:self.receipt image:image];
        [self createCellsTextsAndIndices];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellsTexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_cellsTexts objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSString*) filePathToAttach {
    return [WBAppDelegate instance].filePathToAttach;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Move"])
    {
        WBMoveCopyReceiptViewController* vc = (WBMoveCopyReceiptViewController*)[segue destinationViewController];
        
        vc.calledForCopy = NO;
        vc.receipt = self.receipt;
    }
    
    if ([[segue identifier] isEqualToString:@"Copy"])
    {
        WBMoveCopyReceiptViewController* vc = (WBMoveCopyReceiptViewController*)[segue destinationViewController];
        
        vc.calledForCopy = YES;
        vc.receipt = self.receipt;
    }
    
    if ([[segue identifier] isEqualToString:@"Image"])
    {
        WBImageViewController* vc = (WBImageViewController*)[segue destinationViewController];
        vc.path = [self.receipt imageFilePathForTrip:self.receiptsViewController.trip];
        vc.name = [self.receipt name];
        vc.receiptsViewController = self.receiptsViewController;
    }
    
}

- (IBAction)actionDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
