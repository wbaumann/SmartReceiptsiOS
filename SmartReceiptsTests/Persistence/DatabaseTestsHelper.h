//
//  DatabaseTestsHelper.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"
#import "ReceiptFilesManager.h"

@class WBTrip;
@class Distance;
@class WBReceipt;

@interface ReceiptFilesManager (TestExpose)

- (NSString *)pathForReceiptFile:(WBReceipt *)receipt;
- (NSString *)pathForReceiptFile:(WBReceipt *)receipt withTrip:(WBTrip *)trip;
- (BOOL)fileExistsForReceipt:(WBReceipt *)receipt;
- (NSString *)receiptsFolderForTrip:(WBTrip *)trip;

@end


@interface DatabaseTestsHelper : Database

- (WBTrip *__nonnull)createTestTrip;
- (void)insertTestDistance:(NSDictionary *__nonnull)modifiedParams;
- (void)insertTestReceipt:(NSDictionary *__nonnull)modifiedParams;
- (WBTrip *__nonnull)insertTestTrip:(NSDictionary *__nonnull)modifiedParams;
- (void)insertTestPaymentMethod:(NSString *__nonnull)name;
- (WBReceipt *__nonnull)receiptWithName:(NSString *__nonnull)receiptName;
- (NSArray<WBReceipt *> *__nonnull)allReceipts;

@end
