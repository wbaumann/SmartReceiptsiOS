//
//  FetchedModelAdapterDelegate.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

@protocol FetchedModelAdapterDelegate

- (void)willChangeContent;
- (void)didInsertObject:(id)object atIndex:(NSUInteger)index;
- (void)didDeleteObject:(id)object atIndex:(NSUInteger)index;
- (void)didUpdateObject:(id)object atIndex:(NSUInteger)index;
- (void)didMoveObject:(id)object fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void)didChangeContent;

- (void)reloadData;

@end