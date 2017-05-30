//
//  InputCellsViewController.h
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputCellsSection;

NS_ASSUME_NONNULL_BEGIN

@interface InputCellsViewController : UITableViewController

@property (nonatomic, strong, readonly) NSMutableArray<InputCellsSection *> *presentedSections;
@property (nonatomic, assign) BOOL containNextEditSearchInsideSection;

- (void)addInlinedPickerCell:(UITableViewCell *)cell forCell:(UITableViewCell *)forCell;
- (void)tappedCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@interface InputCellsViewController (ExposeForSwiftExtension) <UITextFieldDelegate>

@property (nonatomic, strong, readonly) NSIndexPath *__nullable presentingPickerForIndexPath;
@property (nonatomic, strong, readonly) NSMutableDictionary *inlinedPickers;

- (NSIndexPath * __nullable)indexPathForCell:(UITableViewCell *)cell;


@end

NS_ASSUME_NONNULL_END