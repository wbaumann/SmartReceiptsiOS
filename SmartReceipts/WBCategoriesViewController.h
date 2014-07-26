//
//  WBCategoriesViewController.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"

#import "WBNewCategoryViewController.h"

@interface WBCategoriesViewController : WBViewController<UITableViewDataSource,UITableViewDelegate,WBNewCategoryViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;

@end
