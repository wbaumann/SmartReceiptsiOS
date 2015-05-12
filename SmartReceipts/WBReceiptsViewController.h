//
//  WBReceiptsViewController.h
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import "WBObservableReceipts.h"
#import "WBNewReceiptViewController.h"

@class WBTrip,WBReceiptsViewController,WBTripsViewController;

@protocol WBReceiptsViewControllerDelegate <NSObject>

-(void) viewController:(WBReceiptsViewController*) viewController updatedTrip:(WBTrip*) trip;

@end

@interface WBReceiptsViewController : WBTableViewController<WBObservableReceiptsDelegate,WBNewReceiptViewControllerDelegate,UITextFieldDelegate>

@property (weak,nonatomic) id<WBReceiptsViewControllerDelegate> delegate;

// trips VC that spawned this VC
@property (weak,nonatomic) WBTripsViewController* tripsViewController;

@property WBTrip* trip;

- (IBAction)actionCamera:(id)sender;

- (void) swapUpReceipt:(WBReceipt*) receipt;
- (void) swapDownReceipt:(WBReceipt*) receipt;

- (BOOL) attachPdfOrImageFile:(NSString*)pdfFile toReceipt:(WBReceipt*) receipt;

- (void) notifyReceiptRemoved:(WBReceipt*) receipt;
- (BOOL) updateReceipt:(WBReceipt*) receipt image:(UIImage*) image;

- (NSUInteger) receiptsCount;

@end
