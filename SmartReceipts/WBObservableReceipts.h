//
//  WBObservableReceipts.h
//  SmartReceipts
//
//  Created on 31/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBReceipt.h"

@class WBObservableReceipts;

@protocol WBObservableReceiptsDelegate <NSObject>

-(void) observableReceipts:(WBObservableReceipts*)observableReceipts filledWithReceipts:(NSArray*) receipts;
-(void) observableReceipts:(WBObservableReceipts*)observableReceipts addedReceipt:(WBReceipt*)receipt atIndex:(int)index;
-(void) observableReceipts:(WBObservableReceipts*)observableReceipts replacedReceipt:(WBReceipt*)oldReceipt toReceipt:(WBReceipt*)newReceipt fromIndex:(int)oldIndex toIndex:(int)newIndex;
-(void) observableReceipts:(WBObservableReceipts*)observableReceipts removedReceipt:(WBReceipt*)receipt atIndex:(int)index;
-(void) observableReceipts:(WBObservableReceipts*)observableReceipts swappedReceiptAtIndex:(int) idx1 withReceiptAtIndex:(int) idx2;

@end

@interface WBObservableReceipts : NSObject

@property (weak,nonatomic) id<WBObservableReceiptsDelegate> delegate;

-(NSUInteger) count;

-(void) setReceipts:(NSArray*) receipts;
-(void) addReceipt:(WBReceipt*) receipt;
-(void) removeReceipt:(WBReceipt*) receipt;
-(void) replaceReceipt:(WBReceipt*) oldReceipt toReceipt:(WBReceipt*) newReceipt;
-(void) swapReceiptAtIndex:(int)idx1 withReceiptAtIndex:(int)idx2;

-(WBReceipt*) receiptAtIndex:(int)index;
-(NSUInteger) indexOfReceipt:(WBReceipt*)receipt;

-(NSArray*) receiptsArrayCopy;

@end
