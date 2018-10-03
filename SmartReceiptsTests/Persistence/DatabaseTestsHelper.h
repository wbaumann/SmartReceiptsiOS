//
//  DatabaseTestsHelper.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "Database.h"
#import "ReceiptFilesManager.h"
#import "ReceiptColumn.h"

@class WBTrip;
@class Distance;
@class WBReceipt;

NS_ASSUME_NONNULL_BEGIN

@interface ReceiptFilesManager (TestExpose)

- (NSString *)pathForReceiptFile:(WBReceipt *)receipt;
- (NSString *)pathForReceiptFile:(WBReceipt *)receipt withTrip:(WBTrip *)trip;
- (BOOL)fileExistsForReceipt:(WBReceipt *)receipt;
- (NSString *)receiptsFolderForTrip:(WBTrip *)trip;

@end


@interface DatabaseTestsHelper : Database

- (WBTrip *__nonnull)createTestTrip;
- (Distance *)insertTestDistance:(NSDictionary *__nonnull)modifiedParams;
- (void)insertTestReceipt:(NSDictionary *__nonnull)modifiedParams;
- (WBTrip *__nonnull)insertTestTrip:(NSDictionary *__nonnull)modifiedParams;
- (void)insertTestPaymentMethod:(NSString *__nonnull)name;
- (WBReceipt *__nonnull)receiptWithName:(NSString *__nonnull)receiptName;
- (NSArray<WBReceipt *> *__nonnull)allReceipts;

- (NSArray<ReceiptColumn *> *__nonnull)getPdfColumns;
- (BOOL)setPdfColumns:(NSArray<ReceiptColumn *> *__nonnull)columns;
- (NSTimeInterval)maxSecondForReceiptsInTrip:(WBTrip *)trip onDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
