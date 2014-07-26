//
//  WBNewCategoryViewController.h
//  SmartReceipts
//
//  Created on 15/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

@class WBNewCategoryViewController, WBCategory;

@protocol WBNewCategoryViewControllerDelegate <NSObject>

-(void)viewController:(WBNewCategoryViewController*)viewController newCategory:(WBCategory*)category;
-(void)viewController:(WBNewCategoryViewController*)viewController updatedCategory:(WBCategory*)oldCategory toCategory:(WBCategory*)newCategory;

@end

@interface WBNewCategoryViewController : WBTableViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionCancel:(id)sender;

@property (weak,nonatomic) id<WBNewCategoryViewControllerDelegate> delegate;
@property WBCategory *category;

@end
