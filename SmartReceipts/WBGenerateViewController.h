//
//  WBGenerateViewController.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import <MessageUI/MessageUI.h>

#import "WBReceipt.h"
#import "WBTrip.h"

@interface WBGenerateViewController : WBTableViewController

@property (nonatomic, strong) WBTrip *trip;

@end
