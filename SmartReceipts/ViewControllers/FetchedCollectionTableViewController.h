//
//  FetchedCollectionTableViewController.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchedModelAdapterDelegate.h"

@class FetchedModelAdapter;

@interface FetchedCollectionTableViewController : UITableViewController <FetchedModelAdapterDelegate>

- (void)setPresentationCellNib:(UINib *)nib;
- (FetchedModelAdapter *)createFetchedModelAdapter;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (void)contentChanged;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfItems;
- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)indexOfObject:(id)object;

@end
