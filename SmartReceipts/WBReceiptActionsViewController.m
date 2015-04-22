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
#import "WBImagePicker.h"

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
}

-(void)createCellsTextsAndIndices {
    
    if ([self.receipt hasImageForTrip:self.receiptsViewController.trip]) {
        _imgType = 1;
    } else if ([self.receipt hasPDFForTrip:self.receiptsViewController.trip]) {
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
                    str = NSLocalizedString(@"Replace Image", nil);
                } else {
                    str = NSLocalizedString(@"Replace Image with PDF", nil);
                }
                break;
                
            case 2:
                if ([[WBAppDelegate instance] isFileImage]) {
                    str = NSLocalizedString(@"Replace PDF with Image", nil);
                } else {
                    str = NSLocalizedString(@"Replace PDF", nil);
                }
                break;
                
            default:
                if ([[WBAppDelegate instance] isFileImage]) {
                    str = NSLocalizedString(@"Attach Image", nil);
                } else {
                    str = NSLocalizedString(@"Attach PDF", nil);
                }
                break;
        }
        
        [cellsIds addObject:@0];
        [cellsTexts addObject:str];
    }
    
    if (_imgType == 1) {
        [cellsIds addObject:@1];
        [cellsTexts addObject:NSLocalizedString(@"View Receipt Image", nil)];
    } else if (_imgType == 2) {
        [cellsIds addObject:@1];
        [cellsTexts addObject:NSLocalizedString(@"View Receipt PDF", nil)];
    }
    
    [cellsIds addObject:@2];
    [cellsTexts addObject:
     (_imgType > 0 ? NSLocalizedString(@"Retake Receipt Image", nil) : NSLocalizedString(@"Take Receipt Image", nil))];
    
    [cellsIds addObject:@3];
    [cellsTexts addObject:NSLocalizedString(@"Move", nil)];
    
    [cellsIds addObject:@4];
    [cellsTexts addObject:NSLocalizedString(@"Copy", nil)];
    
    [cellsIds addObject:@5];
    [cellsTexts addObject:NSLocalizedString(@"Swap Up", nil)];
    
    [cellsIds addObject:@6];
    [cellsTexts addObject:NSLocalizedString(@"Swap Down", nil)];
    
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
            [self.receiptsViewController attachPdfOrImageFile:[self filePathToAttach] toReceipt:self.receipt];
            [[WBAppDelegate instance] freeFilePathToAttach];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
        case 1: {
            // view receipt image
            
            if (_imgType == 1) { // image
                [self performSegueWithIdentifier: @"Image" sender: self];
            } else { // pdf
                [self dismissViewControllerAnimated:YES completion:^{
                    [self showDocumentImage];
                }];
            }
            
            break;
        }
        case 2: {
            // take / replace receipt image
            [self takePhoto];
            break;
        }
        case 3:
            [self performSegueWithIdentifier: @"Move" sender: self];
            break;
            
        case 4:
            [self performSegueWithIdentifier: @"Copy" sender: self];
            break;
            
        case 5:
            [self.receiptsViewController swapUpReceipt:self.receipt];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        case 6:
            [self.receiptsViewController swapDownReceipt:self.receipt];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)takePhoto {
    [[WBImagePicker sharedInstance] presentPickerOnController:self completion:^(UIImage *image) {
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
        
        vc.receiptActionsViewController = self;
        vc.calledForCopy = NO;
    }
    
    if ([[segue identifier] isEqualToString:@"Copy"])
    {
        WBMoveCopyReceiptViewController* vc = (WBMoveCopyReceiptViewController*)[segue destinationViewController];
        
        vc.receiptActionsViewController = self;
        vc.calledForCopy = YES;
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
