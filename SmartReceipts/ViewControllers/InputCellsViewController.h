//
//  InputCellsViewController.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputCellsSection;

@interface InputCellsViewController : UITableViewController

- (void)addSectionForPresentation:(InputCellsSection *)section;
- (void)addInlinedPickerCell:(UITableViewCell *)cell forCell:(UITableViewCell *)forCell;
- (void)tappedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
