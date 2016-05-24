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

@property (nonatomic, strong, readonly) NSMutableArray<InputCellsSection *> *__nonnull presentedSections;
@property (nonatomic, assign) BOOL containNextEditSearchInsideSection;

- (void)addInlinedPickerCell:(UITableViewCell *__nonnull)cell forCell:(UITableViewCell *__nonnull)forCell;
- (void)tappedCell:(UITableViewCell * __nonnull)cell atIndexPath:(NSIndexPath *__nonnull)indexPath;

@end


@interface InputCellsViewController (ExposeForSwiftExtension) <UITextFieldDelegate>

@property (nonatomic, strong, readonly) NSIndexPath *__nullable presentingPickerForIndexPath;

- (NSIndexPath * __nullable)indexPathForCell:(UITableViewCell * __nonnull)cell;

@end