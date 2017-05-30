//
//  WBColumnsViewController.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBViewController.h"
#import "WBDynamicPicker.h"

@interface WBColumnsViewController : WBViewController<WBDynamicPickerDelegate,UITableViewDataSource,UITableViewDelegate>

@property BOOL forCSV;
@property (weak, nonatomic) IBOutlet UITableView *columnsTableView;

- (IBAction)actionAdd:(id)sender;

@end
