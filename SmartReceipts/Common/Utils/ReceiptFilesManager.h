//
//  ReceiptFilesManager.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 17/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class WBReceipt;
@class WBTrip;

@interface ReceiptFilesManager : NSObject

- (id)initWithTripsFolder:(NSString *)pathToTripsFolder;

- (BOOL)saveImage:(UIImage *)image forReceipt:(WBReceipt *)receipt;
- (BOOL)copyFileForReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip;
- (BOOL)moveFileForReceipt:(WBReceipt *)receipt toTrip:(WBTrip *)trip;
- (BOOL)deleteFileForReceipt:(WBReceipt *)receipt;
- (void)deleteFolderForTrip:(WBTrip *)trip;
- (void)renameFolderForTrip:(WBTrip *)trip originalName:(NSString *)originalName;

@end
