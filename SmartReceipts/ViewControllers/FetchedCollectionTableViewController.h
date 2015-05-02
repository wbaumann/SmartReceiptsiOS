//
//  FetchedCollectionTableViewController.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FetchedCollectionTableViewController : UITableViewController

- (void)setPresentationCellNib:(UINib *)nib;
- (NSArray *)fetchPresentedObjects;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (void)contentChanged;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfItems;

@end
