//
//  WBObservableReceipts.m
//  SmartReceipts
//
//  Created on 31/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBObservableReceipts.h"

@implementation WBObservableReceipts
{
    NSMutableArray *array;
}

- (id)init
{
    self = [super init];
    if (self) {
        array = [NSMutableArray array];
    }
    return self;
}

-(NSUInteger) count {
    return [array count];
}

-(void) setReceipts:(NSArray*) receipts {
    array = [receipts mutableCopy];
    [self.delegate observableReceipts:self filledWithReceipts:array];
}

-(void) addReceipt:(WBReceipt*) receipt {
    int pos = [self findIndexForDateMs:[receipt dateMs]];
    [array insertObject:receipt atIndex:pos];
    [self.delegate observableReceipts:self addedReceipt:receipt atIndex:pos];
}

-(void) removeReceipt:(WBReceipt*) receipt {
    int pos = (int)[array indexOfObject:receipt];
    [array removeObjectAtIndex:pos];
    [self.delegate observableReceipts:self removedReceipt:receipt atIndex:pos];
}

-(void) replaceReceipt:(WBReceipt*) oldReceipt toReceipt:(WBReceipt*) newReceipt {
    int oldPos = (int)[array indexOfObject:oldReceipt];
    [array removeObjectAtIndex:oldPos];
    
    int newPos = [self findIndexForDateMs:[newReceipt dateMs]];
    [array insertObject:newReceipt atIndex:newPos];
    
    [self.delegate observableReceipts:self replacedReceipt:oldReceipt toReceipt:newReceipt fromIndex:oldPos toIndex:newPos];
}

- (WBReceipt *)receiptAtIndex:(NSUInteger)index {
    return [array objectAtIndex:index];
}

-(NSUInteger) indexOfReceipt:(WBReceipt*)receipt {
    return [array indexOfObject:receipt];
}

-(void) swapReceiptAtIndex:(int)idx1 withReceiptAtIndex:(int)idx2 {
    [array exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    [self.delegate observableReceipts:self swappedReceiptAtIndex:idx1 withReceiptAtIndex:idx2];
}

-(int) findIndexForDateMs:(long long) dateMs {
    const int count = (int)[array count];
    int i = 0;
    for (; i<count; ++i) {
        long long oed = [[self receiptAtIndex:i] dateMs];
        if (dateMs >= oed) {
            return i;
        }
    }
    return i;
}

-(NSArray*) receiptsArrayCopy {
    return [array copy];
}

@end
