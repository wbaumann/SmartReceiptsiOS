//
//  WBReceiptsViewController.h
//  SmartReceipts
//
//  Created on 12/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "EditReceiptViewController.h"
#import "FetchedCollectionTableViewController.h"

@interface WBReceiptsViewController : FetchedCollectionTableViewController

@property (nonatomic, strong) WBTrip *trip;

+ (NSMutableDictionary *)sharedInputCache;

- (void)swapUpReceipt:(WBReceipt *)receipt;
- (void)swapDownReceipt:(WBReceipt *)receipt;
- (BOOL)attachPdfOrImageFile:(NSString *)pdfFile toReceipt:(WBReceipt *)receipt;
- (BOOL)updateReceipt:(WBReceipt *)receipt image:(UIImage *)image;
- (NSUInteger)receiptsCount;

@end
