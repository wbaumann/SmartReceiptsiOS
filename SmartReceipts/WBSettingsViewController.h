//
//  WBSettingsViewController.h
//  SmartReceipts
//
//  Created on 13/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"
#import "WBDynamicPicker.h"
#import "InputCellsViewController.h"

#import <MessageUI/MessageUI.h>

@interface WBSettingsViewController : InputCellsViewController

+ (WBSettingsViewController*) visibleInstance;

- (void)populateValues;
@end
