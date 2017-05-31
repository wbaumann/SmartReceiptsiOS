//
//  WBColumnsViewController.h
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBDynamicPicker.h"

@interface WBColumnsViewController : UIViewController <WBDynamicPickerDelegate,UITableViewDataSource,UITableViewDelegate>

@property BOOL forCSV;
@property (weak, nonatomic) IBOutlet UITableView *columnsTableView;

- (IBAction)actionAdd:(id)sender;

@end
